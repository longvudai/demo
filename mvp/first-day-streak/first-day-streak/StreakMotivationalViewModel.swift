//
//  StreakMotivationalViewModel.swift
//  first-day-streak
//
//  Created by long vu unstatic on 7/9/21.
//

import Foundation
import Combine

class StreakMotivationalViewModel {
    private lazy var streakMotivationalContent: StreakMotivationalContent? = {
        return self.getStreakMotivationContent()
    }()
    
    var maxNumberOfDayStreak: Int {
        return streakMotivationalContent?.daysContents.count ?? 0
    }
    
    let userName: String
    let habitName: String
    let listDayStreak: [WeekDay]
    let numberOfDayStreak: Int
    
    // MARK: - Initialization
    init(userName: String, habitName: String, numberOfDayStreak: Int, listDayStreak: [WeekDay]) {
        self.userName = userName
        self.habitName = habitName
        self.numberOfDayStreak = numberOfDayStreak
        self.listDayStreak = listDayStreak
    }
    
    // MARK: - helper
    private func getStreakMotivationContent() -> StreakMotivationalContent? {
        return StreakMotivationalContent.mockedValue()
    }
    
    private func getStreakMotivationalContent(by numberOfCurrentDayStreak: Int) -> StreakMotivationalContent.DayContent? {
        guard
            let listContent = streakMotivationalContent?.daysContents,
            (0..<listContent.count).contains(numberOfCurrentDayStreak)
        else {
            return nil
        }
        return listContent[numberOfCurrentDayStreak]
    }
    
    // MARK: - method
    func getStreakMotivationalContent() -> StreakMotivationalContent.DayContent? {
        return getStreakMotivationalContent(by: numberOfDayStreak - 1)
    }
}
