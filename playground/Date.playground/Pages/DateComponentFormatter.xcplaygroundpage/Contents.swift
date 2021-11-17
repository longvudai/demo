//: [Previous](@previous)

import Foundation

let formatter = DateComponentsFormatter()

formatter.maximumUnitCount = 1
formatter.unitsStyle = .abbreviated
formatter.zeroFormattingBehavior = .dropLeading
formatter.allowedUnits = [.day, .hour, .minute, .month]

let now = Date()
let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!
let yesterday2 = Calendar.current.date(byAdding: .day, value: -2, to: now)!

let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: now)!

var calendar = Calendar.current
calendar.firstWeekday = 2
let a = calendar.dateInterval(of: .weekOfYear, for: now)!
let b = calendar.dateInterval(of: .weekOfMonth, for: lastWeek)!


//Set([now, yesterday, yesterday2]).intersection(Set([tomorrow, now, yesterday]))

formatter.string(from: now.timeIntervalSince(lastWeek))
//: [Next](@next)


extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
}

calendar.date(byAdding: .day, value: -1, to: now)?.endOfDay
