//
//  File.swift
//  
//
//  Created by Peter Vu on 3/13/20.
//

import Foundation

public enum Recurrence: Codable, Equatable, Hashable {
    case daily
    case everyWeekDay(Set<WeekDay>)
    case weekly(Int)
    case dayInterval(Int)
    case monthly(Set<Int>)
}

// MARK: - Identifiable
extension Recurrence: Identifiable {
    public var id: String { rawValue }
}

// MARK: - Raw Representable
extension Recurrence: RawRepresentable {
    public typealias RawValue = String
    public var rawValue: String {
        switch self {
        case .daily:
            return "daily"
        case .everyWeekDay(let weekDays):
            let weekDayString = weekDays
                .sorted(by: { $0.rawValue > $1.rawValue })
                .compactMap { $0.rawString }
                .joined(separator: ",")
            return "weekDays-\(weekDayString)"
        case .weekly(let numberOfDay):
            return "weekly-\(numberOfDay)"
        case .dayInterval(let interval):
            return "dayInterval-\(interval)"
        case .monthly(let days):
            let daysString = days
                .sorted(by: { $0 < $1 })
                .compactMap { String($0) }
                .joined(separator: ",")
            return "monthDays-\(daysString)"
        }
    }
    
    public init?(rawValue: String) {
        if rawValue == "daily" {
            self = .daily
        } else if rawValue.contains("weekDays") {
            if let weekDaysRaw = rawValue.components(separatedBy: "-").last?.components(separatedBy: ",") {
                let weekDays = weekDaysRaw.compactMap { WeekDay(rawString: $0) }
                self = .everyWeekDay(Set<WeekDay>(weekDays))
            } else {
                return nil
            }
        } else if let numberOfDayRaw = rawValue.components(separatedBy: "-").last, let numberOfDay = Int(numberOfDayRaw), rawValue.contains("weekly") {
            self = .weekly(numberOfDay)
        } else if let intervalValueString = rawValue.components(separatedBy: "-").last, let intervalValue = Int(intervalValueString), rawValue.contains("dayInterval") {
            self = .dayInterval(intervalValue)
        } else if rawValue.contains("monthDays") {
            if let monthDaysRaw = rawValue.components(separatedBy: "-").last?.components(separatedBy: ",") {
                let monthDays = monthDaysRaw.compactMap { Int($0) }
                self = .monthly(Set(monthDays))
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

// MARK: - Convenience
public extension Recurrence {
    var weekDays: [WeekDay] {
        switch self {
        case .daily, .weekly, .dayInterval:
            return WeekDay.allCases
            
        case .everyWeekDay(let weekDays):
            return .init(weekDays)
            
        case .monthly:
            return WeekDay.allCases
        }
    }
    
    func containsWeekDay(_ weekDay: WeekDay) -> Bool {
        return weekDays.contains(weekDay)
    }
    
    init(weekDays: Set<WeekDay>) {
        if WeekDay.allCasesSet.subtracting(weekDays).isEmpty {
            self = .daily
        } else {
            self = .everyWeekDay(weekDays)
        }
    }
    
    func isSameType(withAnotherRegularly regularly: Recurrence) -> Bool {
        switch (self, regularly) {
        case (.daily, .daily):
            return true
            
        case (.everyWeekDay, .everyWeekDay):
            return true
            
        case (.weekly, .weekly):
            return true
            
        case (.dayInterval, .dayInterval):
            return true
            
        default:
            return false
        }
    }
}

private extension WeekDay {
    static var allCasesSet: Set<Self> = .init(Self.allCases)
}

extension Recurrence {
    var localizedString: String {
        switch self {
        case .daily, .everyWeekDay:
            let weekendDays: [WeekDay] = [.sun, .sat]
            let weekdays: [WeekDay] = [.mon, .tue, .wed, .thu, .fri]
            if weekDays == weekendDays {
                return NSLocalizedString("weekends", tableName: "Common", comment: "")
            } else if weekDays == weekdays {
                return NSLocalizedString("weekdays", tableName: "Common", comment: "")
            } else if weekDays.count == WeekDay.allCases.count {
                return NSLocalizedString("everyday", tableName: "Common", comment: "")
            } else {
                return weekDays
                    .sorted { $0.rawValue < $1.rawValue }
                    .compactMap { Calendar.current.shortWeekDaySymbol(from: $0) }
                    .joined(separator: ", ")
            }
            
        case .weekly(let numberOfTime):
            return String(format: NSLocalizedString("day.per.week",
                                                    tableName: "Plurals",
                                                    comment: ""), numberOfTime)
            
        case .dayInterval(let interval):
            return String(format: NSLocalizedString("interval.day",
                                                    tableName: "Plurals",
                                                    comment: ""), interval)
            
        case .monthly(let days):
            let formatter = NumberFormatter()
            formatter.numberStyle = .ordinal
            let daysString = days
                .sorted()
                .map { NSNumber(value: $0) }
                .compactMap { formatter.string(from: $0) }
            
            return daysString.joined()
        }
    }
}

extension Recurrence {
    func contains(_ date: Date, startDate: Date, calendar: Calendar) -> Bool {
        switch self {
        case .daily:
            return true
            
        case .everyWeekDay(let weekdays):
            guard let targetWeekday = calendar.weekDay(from: date) else {
                return false
            }
            return weekdays.contains(targetWeekday)
            
        case .dayInterval(let interval):
            if calendar.isDate(startDate, inSameDayAs: date) {
                return true
            }
            
            guard let startOfDayForStartDate = calendar.dateInterval(of: .day, for: startDate)?.start else {
                return false
            }
            
            guard let numberOfDayPassedFromStartDate = calendar.dateComponents([.day],
                                                                               from: startOfDayForStartDate,
                                                                               to: date).day else {
                return false
            }
            
            return numberOfDayPassedFromStartDate % interval == 0
            
        case .weekly:
            return true
            
        case .monthly(let days):
            let targetDay =  calendar.component(.day, from: date)
            return days.contains(targetDay)
        }
    }
}
