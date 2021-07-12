//
//  StreakMotivationalContent.swift
//  iOS
//
//  Created by long vu unstatic on 7/9/21.
//  Copyright © 2021 Peter Vu. All rights reserved.
//

import Foundation
import SwiftyJSON

struct StreakMotivationalContent: Codable, JSONCovertible {
    let daysContents: [DayContent]
    
    static func from(_ json: JSON) throws -> StreakMotivationalContent {
        guard let array = json["daysContents"].array else {
            throw SwiftyJSONError.notExist
        }
        let daysContents = array.compactMap { try? DayContent.from($0) }
        return StreakMotivationalContent(daysContents: daysContents)
    }
}

extension StreakMotivationalContent {
    static func mockedValue() -> StreakMotivationalContent {
        let dayContents = [DayContent.mockedValue()]
        return StreakMotivationalContent(daysContents: dayContents)
    }
}

extension StreakMotivationalContent {
    struct DayContent: Codable, JSONCovertible {
        let title: String
        let subtitle: String
        let motivationalLetter: MotivationalLetter
        let primaryAction: PrimaryAction
        
        static func from(_ json: JSON) throws -> DayContent {
            guard
                let title = json["title"].string,
                let subtitle = json["subtitle"].string,
                let motivationalLetter = try? MotivationalLetter.from(json["motivationalLetter"]),
                let primaryAction = try? PrimaryAction.from(json["primaryAction"])
            else {
                throw SwiftyJSONError.invalidJSON
            }
            
            return DayContent(
                title: title,
                subtitle: subtitle,
                motivationalLetter: motivationalLetter,
                primaryAction: primaryAction
            )
        }
    }
}

// MARK: - Mock StreakMotivationalContent.DayContent
extension StreakMotivationalContent.DayContent {
    static func mockedValue() -> StreakMotivationalContent.DayContent {
        return StreakMotivationalContent.DayContent(
            title: "Your First Streak",
            subtitle: "That’s great start! Let’s keep it up to gain your first 3 day streak",
            motivationalLetter: StreakMotivationalContent.MotivationalLetter(
                content: "We're really happy to see your first steps on this memorable journey of becoming.",
                dismissButtonTitle: "Got It"
            ),
            primaryAction: StreakMotivationalContent.PrimaryAction(
                title: "Read Our Letter",
                actionType: .readMotivationalLetter
            )
        )
    }
}

extension StreakMotivationalContent {
    struct MotivationalLetter: Codable, JSONCovertible {
        let content: String
        let dismissButtonTitle: String
        
        static func from(_ json: JSON) throws -> StreakMotivationalContent.MotivationalLetter {
            guard
                let content = json["content"].string,
                let dismissButtonTitle = json["dismissButtonTitle"].string
            else {
                throw SwiftyJSONError.invalidJSON
            }
            
            return MotivationalLetter(content: content, dismissButtonTitle: dismissButtonTitle)
        }
    }
}

extension StreakMotivationalContent.MotivationalLetter {
    static func mockedValue() -> StreakMotivationalContent.MotivationalLetter {
        return Self(content: "We're really happy to see your first steps on this memorable journey of becoming. \nGrowth is a life-long process. The day you sow the seed isn't the day you eat the fruit, so don’t let yourself become too obsessed with hurrying to get there. More than anything, we wish you patience, perseverance, and joy. Keep going, steadily, you will make it to wherever you want to be. ", dismissButtonTitle: "Got It")
    }
}

extension StreakMotivationalContent {
    struct PrimaryAction: Codable, JSONCovertible {
        enum ActionType: String, Codable {
            case share, readMotivationalLetter, dismiss
        }
        
        let title: String
        let actionType: ActionType
        
        static func from(_ json: JSON) throws -> StreakMotivationalContent.PrimaryAction {
            guard
                let title = json["title"].string,
                let actionTypeRawValue = json["actionType"].string,
                let actionType = ActionType(rawValue: actionTypeRawValue)
            else {
                throw SwiftyJSONError.invalidJSON
            }
            
            return PrimaryAction(title: title, actionType: actionType)
        }
    }
}
