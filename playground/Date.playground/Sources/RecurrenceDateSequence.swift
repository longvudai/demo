//
//  RecurrenceDateSequence.swift
//  macOS-SwiftUI
//
//  Created by Peter Vu on 4/13/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

import Foundation

public struct RecurrenceDateSequence: Sequence {
    var startDate: Date
    var endDate: Date
    var regularly: Recurrence
    var calendar: Calendar
    var direction: Calendar.SearchDirection = .forward
    
    public init(
        startDate: Date,
        endDate: Date,
        regularly: Recurrence,
        calendar: Calendar = .current,
        direction: Calendar.SearchDirection
    ) {
        self.startDate = startDate
        self.endDate = endDate
        self.regularly = regularly
        self.calendar = calendar
        self.direction = direction
    }

    public func makeIterator() -> SpecificDateIterator {
        return SpecificDateIterator(sequence: self)
    }
}

public extension RecurrenceDateSequence {
    struct SpecificDateIterator: IteratorProtocol {
        let sequence: RecurrenceDateSequence
        private var anchorDate: Date
        private let matchingComponents = DateComponents(hour: 0, minute: 0, second: 0)

        init(sequence: RecurrenceDateSequence) {
            self.anchorDate = sequence.calendar.date(byAdding: .day, value: sequence.direction == .forward ? -1 : 0, to: sequence.startDate) ?? sequence.startDate
            self.sequence = sequence
        }

        mutating public func next() -> Date? {
            var foundedDate: Date?

            sequence
                .calendar
                .enumerateDates(startingAfter: anchorDate,
                                matching: matchingComponents,
                                matchingPolicy: .nextTime,
                                direction: sequence.direction) { nextDate, _, stop in
                                    if let foundedValue = nextDate {
                                        guard self.isDateInRange(foundedValue) else {
                                            stop = true
                                            return
                                        }
                                        if self.isDateValidForRecurrence(foundedValue) {
                                            foundedDate = foundedValue
                                            self.anchorDate = foundedValue
                                            stop = true
                                        }
                                    } else {
                                        stop = true
                                    }
                }

            return foundedDate
        }

        private func isDateValidForRecurrence(_ targetDate: Date) -> Bool {
            switch sequence.regularly {
            case .daily:
                return true

            case .dayInterval(let interval):
                // if direction is backward and regularly is dayInterval => date compare is enddate
                 if let numberOfDayPassedFromStartDate = sequence.calendar.dateComponents([.day], from: sequence.direction == .forward ? sequence.startDate : sequence.endDate, to: targetDate).day, numberOfDayPassedFromStartDate % interval == 0 {
                    return true
                }

            case .everyWeekDay(let weekdays):
                if let currentWeekday = sequence.calendar.weekDay(from: targetDate), weekdays.contains(currentWeekday) {
                    return true
                }

            case .weekly:
                break

            case .monthly(let days):
                let targetDay =  sequence.calendar.component(.day, from: targetDate)
                return days.contains(targetDay)
            }
            return false
        }

        private func isDateInRange(_ targetDate: Date) -> Bool {
            let endDateComparisionResult = sequence.calendar.compare(targetDate,
                                                                     to: sequence.endDate,
                                                                     toGranularity: .day)
            switch sequence.direction {
            case .forward:
                return endDateComparisionResult != .orderedDescending

            case .backward:
                return endDateComparisionResult != .orderedAscending
            @unknown default:
                assert(false, "Unable to handle new Calendar search direction")
                return false
            }
        }
    }
}
