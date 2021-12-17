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

func relativeString(from date: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .short
    let relativeDateString = formatter.localizedString(for: date, relativeTo: Date())
    return relativeDateString
}

relativeString(from: Date())
relativeString(from: Date().addingTimeInterval(60 * -15))
relativeString(from: Date().addingTimeInterval(-6 * 86400))

relativeString(from: Date().addingTimeInterval(50 * 86400))
