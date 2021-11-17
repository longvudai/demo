//: [Previous](@previous)

import Foundation

let calendar = Calendar.current

let now = Date()

let startDate = calendar.date(byAdding: .day, value: -3, to: now) ?? Date()

let dateSequence = DateSequence(
    calendar: calendar,
    startDate: startDate,
    endDate: now,
    stepComponent: .day,
    stepValue: 1,
    includeStartDate: true
)

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "dd/MM/YYYY"
let dates = dateSequence.map { dateFormatter.string(from: $0) }
print(dates)
