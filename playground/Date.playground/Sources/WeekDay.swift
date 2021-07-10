//
//  File.swift
//  
//
//  Created by Peter Vu on 1/13/20.
//

import Foundation

public enum WeekDay: Int, CaseIterable, Codable, Equatable, Identifiable {
    case sun = 1, mon, tue, wed, thu, fri, sat

    public var id: Int { rawValue }
    private static var allCaseMap: [String: WeekDay] = {
        return .init(uniqueKeysWithValues: Self.allCases.map({ (key: $0.rawString, value: $0) }))
    }()

    public var rawString: String {
        switch self {
        case .sun:
            return "sun"
        case .mon:
            return "mon"
        case .tue:
            return "tue"
        case .wed:
            return "wed"
        case .thu:
            return "thu"
        case .fri:
            return "fri"
        case .sat:
            return "sat"
        }
    }

    public init?(rawString: String) {
        if let firstMatch = Self.allCaseMap[rawString] {
            self = firstMatch
        } else {
            return nil
        }
    }

    public func weekDayRaw(from calendar: Calendar = Calendar(identifier: .gregorian)) -> Int {
        let defaultCalendar = Calendar(identifier: .gregorian)
        var defaultDateComponents = defaultCalendar.dateComponents([.weekday, .month, .hour, .minute, .year, .weekOfYear, .weekOfMonth, .second], from: Date())
        defaultDateComponents.weekday = rawValue

        let weekDayConverted = calendar.component(.weekday, from: defaultCalendar.date(from: defaultDateComponents) ?? Date())
        return weekDayConverted
    }
}

public extension Calendar {
    public func weekDay(from targetDate: Date) -> WeekDay? {
        let weekDayComponent = component(.weekday, from: targetDate)
        if let convertedWeekDay = WeekDay(rawValue: weekDayComponent) {
            return convertedWeekDay
        } else {
            return nil
        }
    }
}

public extension Calendar {
    func weekdaySymbol(from weekday: WeekDay) -> String {
        let weekDayRaw = weekday.weekDayRaw(from: self)
        return weekdaySymbols[weekDayRaw - 1]
    }

    func shortWeekDaySymbol(from weekday: WeekDay) -> String {
        let weekDayRaw = weekday.weekDayRaw(from: self)
        return shortWeekdaySymbols[weekDayRaw - 1]
    }

    func veryShortWeekDaySymbol(from weekday: WeekDay) -> String {
        let weekDayRaw = weekday.weekDayRaw(from: self)
        return veryShortWeekdaySymbols[weekDayRaw - 1]
    }
}

public extension Calendar {
    static func current(firstDayOfWeek: WeekDay) -> Calendar {
        var current = self.current
        current.firstWeekday = firstDayOfWeek.rawValue
        return current
    }
}
