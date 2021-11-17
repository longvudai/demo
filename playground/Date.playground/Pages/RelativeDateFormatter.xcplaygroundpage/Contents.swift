//: [Previous](@previous)

import Foundation

let calendar = Calendar.current

let relativeFormatter = DateFormatter()
relativeFormatter.doesRelativeDateFormatting = true
relativeFormatter.timeStyle = .none
relativeFormatter.dateStyle = .long

let nonRelativeFormatter = DateFormatter()
nonRelativeFormatter.timeStyle = .none
nonRelativeFormatter.dateStyle = .short
nonRelativeFormatter.dateFormat = "EEEE MMM d"

func stringFromDate(date: Date) -> String {
    let relativeDateString = relativeFormatter.string(from: date)
    let nonRelativeDateString = nonRelativeFormatter.string(from: date)

    if let _ = relativeDateString.rangeOfCharacter(from: .decimalDigits) {
        return nonRelativeDateString
    } else {
        return "\(relativeDateString), \(nonRelativeDateString)"
    }
}
let date1 = Date()
let date2 = calendar.date(byAdding: .month, value: -1, to: Date())!
stringFromDate(date: date1)
stringFromDate(date: date2)


//: [Next](@next)
