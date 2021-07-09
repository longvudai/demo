//
//  PrimaryAction.swift
//  first-day-streak
//
//  Created by long vu unstatic on 7/9/21.
//

import Foundation

struct PrimaryAction {
    enum ActionType {
        case share, readMotivationalLetter, dismiss
    }
    
    let title: String
    let actionType: ActionType
}
