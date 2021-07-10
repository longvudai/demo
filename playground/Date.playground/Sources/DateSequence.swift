import Foundation
import Combine

public struct DateSequence: Sequence {
    public var calendar: Calendar
    public var startDate: Date
    public var endDate: Date
    public let stepComponent: Calendar.Component
    public let stepValue: Int

    public func makeIterator() -> Iterator {
        return Iterator(range: self)
    }

    public var count: Int {
        if stepValue == 0 {
            return 0
        }

        let components = calendar.dateComponents([stepComponent], from: startDate, to: endDate)
        return (components.value(for: stepComponent) ?? 0) / stepValue
    }

    init(interval: DateInterval, calendar: Calendar, stepComponent: Calendar.Component, stepValue: Int, includeStartDate: Bool = false) {
        self.init(calendar: calendar,
                  startDate: interval.start,
                  endDate: interval.end,
                  stepComponent: stepComponent,
                  stepValue: stepValue,
                  includeStartDate: includeStartDate)
    }

    public init(calendar: Calendar,
                startDate: Date,
                endDate: Date,
                stepComponent: Calendar.Component,
                stepValue: Int,
                includeStartDate: Bool = false) {
        self.calendar = calendar
        if includeStartDate {
            self.startDate = calendar.date(byAdding: stepComponent, value: -stepValue, to: startDate) ?? startDate
        } else {
            self.startDate = startDate
        }
        self.endDate = endDate
        self.stepComponent = stepComponent
        self.stepValue = stepValue
    }

    public struct Iterator: IteratorProtocol {
        var range: DateSequence

        mutating public func next() -> Date? {
            guard let nextDate = range.calendar.date(byAdding: range.stepComponent, value: range.stepValue, to: range.startDate) else {
                return nil
            }

            let comparisionResult = range.calendar.compare(range.endDate, to: nextDate, toGranularity: range.stepComponent)

            if comparisionResult == .orderedAscending {
                return nil
            } else {
                range.startDate = nextDate
                return nextDate
            }
        }
    }

    public func contains(_ element: Iterator.Element) -> Bool {
        return (element.timeIntervalSince1970 >= startDate.timeIntervalSince1970) && (element.timeIntervalSince1970 <= endDate.timeIntervalSince1970)
    }
}

public extension Calendar {
    func beginningOf(_ component: Calendar.Component, for date: Date) -> Date? {
        return dateInterval(of: component, for: date)?.start
    }

    func endOf(_ component: Calendar.Component, for date: Date) -> Date? {
        return dateInterval(of: component, for: date)?.end.addingTimeInterval(-1)
    }
}

public extension Calendar {
    func weekRanges(from startDate: Date, to endDate: Date) -> [DateSequence] {
        guard let start = beginningOf(.weekOfYear, for: startDate),
              let end = endOf(.weekOfYear, for: endDate) else {
            return []
        }

        let dateRange = DateSequence(calendar: self,
                                     startDate: start,
                                     endDate: end,
                                     stepComponent: .weekOfYear,
                                     stepValue: 1,
                                     includeStartDate: true)

        var dates = dateRange.sorted()
        dates.append(endDate)

        var lastDate: Date = startDate
        var weekRanges: [DateSequence] = []

        for date in dates {
            let newRange = DateSequence(calendar: self,
                                        startDate: lastDate,
                                        endDate: date.addingTimeInterval(-60*60*24),
                                        stepComponent: .day,
                                        stepValue: 1)
            lastDate = date
            weekRanges.append(newRange)
        }

        if var lastRange = weekRanges.last {
            lastRange.endDate = endDate
            weekRanges[weekRanges.count - 1] = lastRange
        }

        return weekRanges
    }
}

public extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
           return calendar.dateComponents(Set(components), from: self)
       }

       func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
           return calendar.component(component, from: self)
       }
}

extension Sequence {
    /// Return the sequence with all duplicates removed.
    ///
    /// Duplicate, in this case, is defined as returning `true` from `comparator`.
    ///
    /// - note: Taken from stackoverflow.com/a/46354989/3141234
    func uniqued(comparator: @escaping (Element, Element) throws -> Bool) rethrows -> [Element] {
        var buffer: [Element] = []

        for element in self {
            // If element is already in buffer, skip to the next element
            if try buffer.contains(where: { try comparator(element, $0) }) {
                continue
            }

            buffer.append(element)
        }

        return buffer
    }
}
