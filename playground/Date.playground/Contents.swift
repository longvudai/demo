import UIKit
import Foundation

var greeting = "Hello, playground"

let calendar = Calendar.current

let isoDate = "2021-07-01T10:44:00+0000"
let dateFormatter = ISO8601DateFormatter()
let date1 = dateFormatter.date(from:isoDate)!


let sequence = calendar.weekRanges(from: date1, to: Date())

let a = RecurrenceDateSequence(
    startDate: date1,
    endDate: Date(),
    regularly: Recurrence.monthly(Set<Int>(arrayLiteral: 1, 3, 23, 31)),
    calendar: calendar,
    direction: .forward
)

print(Array(a))
