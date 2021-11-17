import UIKit
import Foundation

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

extension Calendar {

func dayOfWeek(_ date: Date) -> Int {
    var dayOfWeek = self.component(.weekday, from: date) + 1 - self.firstWeekday

    if dayOfWeek <= 0 {
        dayOfWeek += 7
    }

    return dayOfWeek
}

func startOfWeek(_ date: Date) -> Date {
    return self.date(byAdding: DateComponents(day: -self.dayOfWeek(date) + 1), to: date)!
}

func endOfWeek(_ date: Date) -> Date {
    return self.date(byAdding: DateComponents(day: 6), to: self.startOfWeek(date))!
}

func startOfMonth(_ date: Date) -> Date {
    return self.date(from: self.dateComponents([.year, .month], from: date))!
}

func endOfMonth(_ date: Date) -> Date {
    return self.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(date))!
}

func startOfQuarter(_ date: Date) -> Date {
    let quarter = (self.component(.month, from: date) - 1) / 3 + 1
    return self.date(from: DateComponents(year: self.component(.year, from: date), month: (quarter - 1) * 3 + 1))!
}

func endOfQuarter(_ date: Date) -> Date {
    return self.date(byAdding: DateComponents(month: 3, day: -1), to: self.startOfQuarter(date))!
}

func startOfYear(_ date: Date) -> Date {
    return self.date(from: self.dateComponents([.year], from: date))!
}

func endOfYear(_ date: Date) -> Date {
    return self.date(from: DateComponents(year: self.component(.year, from: date), month: 12, day: 31))!
}
}

var greeting = "Hello, playground"

let calendar = Calendar.current

let currentDate = Date()

let thisDayLastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date())

print("firstDayOfTheMonth", calendar.startOfMonth(currentDate))
print("firstDayOfTheWeek", calendar.startOfWeek(currentDate))


let startOfWeek = calendar.startOfWeek(currentDate)


var dateComponent = calendar.dateComponents([.month], from: currentDate)
dateComponent.month = (dateComponent.month ?? 0) - 1
calendar.date(from: dateComponent)


// test habitify
let dailyDateComponent = calendar.dateComponents([.day, .month, .year], from: currentDate)
let date1 = calendar.date(from: dailyDateComponent)

let weeklyDateComponent = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear, .year], from: currentDate)
let date2 = calendar.date(from: weeklyDateComponent)

var monthlyDateComponent = calendar.dateComponents([.month, .year], from: currentDate)
let date3 = calendar.date(from: monthlyDateComponent)

extension Calendar {
    func quantityDateInterval(for dateComponents: DateComponents) -> DateInterval? {
        guard let date = date(from: dateComponents) else {
                return nil
            }
        if dateComponents.day != nil && dateComponents.month != nil && dateComponents.year != nil {
            return dateInterval(of: .day, for: date)
        } else if dateComponents.weekOfYear != nil && dateComponents.year != nil && dateComponents.yearForWeekOfYear != nil {
            return dateInterval(of: .weekOfYear, for: date)
        } else if dateComponents.month != nil && dateComponents.year != nil {
            return dateInterval(of: .month, for: date)
        } else {
            return nil
        }
    }
}

let dateInterval = calendar.quantityDateInterval(for: monthlyDateComponent)
let newDate = calendar.date(byAdding: .day, value: -7, to: dateInterval!.start)

