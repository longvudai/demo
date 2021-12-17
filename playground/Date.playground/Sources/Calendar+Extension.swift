import Foundation

public extension Calendar {
    func endOfDayBeforeDay(_ date: Date) -> Date {
        startOfDay(for: date).addingTimeInterval(-1)
    }

    func endOfDay(_ date: Date) -> Date? {
        let startOfDay = self.startOfDay(for: date)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return self.date(byAdding: components, to: startOfDay)
    }

    func startOfDayAfterDay(_ date: Date) -> Date? {
        endOfDay(date)?.addingTimeInterval(1)
    }

    var tomorrow: Date? {
        startOfDayAfterDay(Date())
    }
}
