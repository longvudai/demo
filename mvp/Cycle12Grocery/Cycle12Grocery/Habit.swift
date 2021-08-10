//
//  Habit.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/9/21.
//

import Foundation

struct Habit: Hashable {
    let title: String
    let currentValue: Float
    let targetValue: Float
    var habitIconName: String?
}

extension Habit {
    static var mockedValue1: Habit {
        return Habit(title: "Item 1", currentValue: 0, targetValue: 10, habitIconName: "mediate")
    }
    
    static var mockedValue2: Habit {
        return Habit(title: "Item 2 very long title hehe huhu kaka", currentValue: 3, targetValue: 10)
    }
}
