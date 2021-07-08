//
//  DayStreakViewController+Model.swift
//  first-day-streak
//
//  Created by long vu unstatic on 7/8/21.
//

import Foundation

struct MotivationLetter {
    let content: String
    let dismissButtonTitle: String
}

extension MotivationLetter {
    static func mockedValue() -> MotivationLetter {
        return Self(content: "We're really happy to see your first steps on this memorable journey of becoming. \nGrowth is a life-long process. The day you sow the seed isn't the day you eat the fruit, so don’t let yourself become too obsessed with hurrying to get there. More than anything, we wish you patience, perseverance, and joy. Keep going, steadily, you will make it to wherever you want to be. ", dismissButtonTitle: "Got It")
    }
}
