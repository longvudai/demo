import Foundation
import UIKit

extension Date {
    static var yesterday: Date { Date().dayBefore }
    static var tomorrow: Date { Date().dayAfter }
    var dayBefore: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }

    var dayAfter: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }

    var noon: Date {
        Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

    var month: Int {
        Calendar.current.component(.month, from: self)
    }

    var isLastDayOfMonth: Bool {
        dayAfter.month != month
    }
}

extension Calendar {
    func dayOfWeek(_ date: Date) -> Int {
        var dayOfWeek = component(.weekday, from: date) + 1 - firstWeekday

        if dayOfWeek <= 0 {
            dayOfWeek += 7
        }

        return dayOfWeek
    }

    func startOfWeek(_ date: Date) -> Date {
        self.date(byAdding: DateComponents(day: -dayOfWeek(date) + 1), to: date)!
    }

    func endOfWeek(_ date: Date) -> Date {
        self.date(byAdding: DateComponents(day: 6), to: startOfWeek(date))!
    }

    func startOfMonth(_ date: Date) -> Date {
        self.date(from: dateComponents([.year, .month], from: date))!
    }

    func endOfMonth(_ date: Date) -> Date {
        self.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth(date))!
    }

    func startOfQuarter(_ date: Date) -> Date {
        let quarter = (component(.month, from: date) - 1) / 3 + 1
        return self.date(from: DateComponents(year: component(.year, from: date), month: (quarter - 1) * 3 + 1))!
    }

    func endOfQuarter(_ date: Date) -> Date {
        self.date(byAdding: DateComponents(month: 3, day: -1), to: startOfQuarter(date))!
    }

    func startOfYear(_ date: Date) -> Date {
        self.date(from: dateComponents([.year], from: date))!
    }

    func endOfYear(_ date: Date) -> Date {
        self.date(from: DateComponents(year: component(.year, from: date), month: 12, day: 31))!
    }
}
