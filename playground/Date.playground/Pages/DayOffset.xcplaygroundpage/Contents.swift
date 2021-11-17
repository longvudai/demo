//: [Previous](@previous)

import Foundation

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
    
    func numberOfMonthsBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.month, .year], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.month!
    }
}

let calendar = Calendar.current
let now = Date()
let x = Date(timeIntervalSince1970: 1632967274)
let y = Date(timeIntervalSince1970: 1630288874)
calendar.numberOfMonthsBetween(now, and: y)

//: [Next](@next)
