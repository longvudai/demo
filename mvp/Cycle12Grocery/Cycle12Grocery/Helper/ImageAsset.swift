//
//  NewJournalImage.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/10/21.
//

import Foundation
import SwiftUI
import UIKit

enum ImageAsset: String {
    case journalOptionButton = "JournalOptionButton"
    case journalTitleIcon = "JournalTitleIcon"
    
    case swipeUndoAction = "SwipeUndoAction"
    
    case smartActionAutomation = "heart"
    case smartActionTimer = "SmartActionTimer"
    case smartActionCompleted = "SmartActionTick"
    case smartActionLogValue = "SmartActionLogValue"
    
    case journalIconLayout = "JournalIconLayout"
    case journalIconlessLayout = "JournalIconlessLayout"
    
    case journalSettingIcon = "JournalSettingIcon"
    
    // Journal option
    case journalOptionAlphabeticalOrder = "JournalOptionAlphabeticalOrder"
    case journalOptionMyHabitsOrder = "JournalOptionMyHabitsOrder"
    case journalOptionReminderTimeOrder = "JournalOptionReminderTimeOrder"
    
    // Habit Edit
    case habitEditColorPicker = "ColorPickerIcon"
    
    // Habit icon
    case icon1 = "5d5f4a18-fc06-11eb-9a03-0242ac130003"
    case icon2 = "5d5f4c5c-fc06-11eb-9a03-0242ac130003"
    case icon3 = "5d5f4d4c-fc06-11eb-9a03-0242ac130003"
    case icon4 = "5d5f4e14-fc06-11eb-9a03-0242ac130003"
    case icon5 = "5d5f50b2-fc06-11eb-9a03-0242ac130003"
    case icon6 = "5d5f5184-fc06-11eb-9a03-0242ac130003"
    case icon7 = "5d5f5238-fc06-11eb-9a03-0242ac130003"
    case icon8 = "5d5f52f6-fc06-11eb-9a03-0242ac130003"
    case icon9 = "5d5f53aa-fc06-11eb-9a03-0242ac130003"
    case icon10 = "5d5f545e-fc06-11eb-9a03-0242ac130003"
    case icon11 = "5d5f5512-fc06-11eb-9a03-0242ac130003"
    case icon12 = "5d5f57c4-fc06-11eb-9a03-0242ac130003"
    case icon13 = "5d5f588c-fc06-11eb-9a03-0242ac130003"
    case icon14 = "5d5f5940-fc06-11eb-9a03-0242ac130003"
    case icon15 = "5d5f59fe-fc06-11eb-9a03-0242ac130003"
    case icon16 = "5d5f5ab2-fc06-11eb-9a03-0242ac130003"
    case icon17 = "5d5f5b66-fc06-11eb-9a03-0242ac130003"
    case icon18 = "5d5f5cc4-fc06-11eb-9a03-0242ac130003"
    case icon19 = "5d5f5eea-fc06-11eb-9a03-0242ac130003"
    case icon20 = "5d5f5fa8-fc06-11eb-9a03-0242ac130003"
    case icon21 = "5d5f6066-fc06-11eb-9a03-0242ac130003"
    case icon22 = "5d5f6110-fc06-11eb-9a03-0242ac130003"
    case icon23 = "5d5f61c4-fc06-11eb-9a03-0242ac130003"
    case icon24 = "5d5f6282-fc06-11eb-9a03-0242ac130003"
    case icon25 = "5d5f6336-fc06-11eb-9a03-0242ac130003"
    case icon26 = "5d5f6610-fc06-11eb-9a03-0242ac130003"
    case icon27 = "5d5f66d8-fc06-11eb-9a03-0242ac130003"
    case icon28 = "5d5f678c-fc06-11eb-9a03-0242ac130003"
    case icon29 = "5d5f6840-fc06-11eb-9a03-0242ac130003"
    case icon30 = "5d5f68f4-fc06-11eb-9a03-0242ac130003"
    case icon31 = "5d5f699e-fc06-11eb-9a03-0242ac130003"
    case icon32 = "5d5f6a5c-fc06-11eb-9a03-0242ac130003"
    case icon33 = "5d5f6b10-fc06-11eb-9a03-0242ac130003"
    case icon34 = "5d5f6d18-fc06-11eb-9a03-0242ac130003"
    case icon35 = "5d5f6dcc-fc06-11eb-9a03-0242ac130003"
    case icon36 = "5d5f6e80-fc06-11eb-9a03-0242ac130003"
    case icon37 = "5d5f6f34-fc06-11eb-9a03-0242ac130003"
    case icon38 = "5d5f6ff2-fc06-11eb-9a03-0242ac130003"
    case icon39 = "5d5f70a6-fc06-11eb-9a03-0242ac130003"
    case icon40 = "5d5f715a-fc06-11eb-9a03-0242ac130003"
    case icon41 = "5d5f720e-fc06-11eb-9a03-0242ac130003"
    case icon42 = "5d5f74d4-fc06-11eb-9a03-0242ac130003"
    case icon43 = "5d5f7588-fc06-11eb-9a03-0242ac130003"
    case icon44 = "5d5f76f0-fc06-11eb-9a03-0242ac130003"
    case icon45 = "5d5f77a4-fc06-11eb-9a03-0242ac130003"
    case icon46 = "5d5f7858-fc06-11eb-9a03-0242ac130003"
    case icon47 = "5d5f790c-fc06-11eb-9a03-0242ac130003"
    case icon48 = "5d5f79ca-fc06-11eb-9a03-0242ac130003"
    case icon49 = "5d5f7bb4-fc06-11eb-9a03-0242ac130003"
    case icon50 = "5d5f7c72-fc06-11eb-9a03-0242ac130003"
    case icon51 = "5d5f7d26-fc06-11eb-9a03-0242ac130003"
    case icon52 = "5d5f7dda-fc06-11eb-9a03-0242ac130003"
    case icon53 = "5d5f7e8e-fc06-11eb-9a03-0242ac130003"
    case icon54 = "5d5f7f42-fc06-11eb-9a03-0242ac130003"
    case icon55 = "5d5f7ff6-fc06-11eb-9a03-0242ac130003"
    case icon56 = "5d5f81f4-fc06-11eb-9a03-0242ac130003-1"
    case icon57 = "5d5f81f4-fc06-11eb-9a03-0242ac130003"
    case icon58 = "5d5f838e-fc06-11eb-9a03-0242ac130003-1"
    case icon59 = "5d5f838e-fc06-11eb-9a03-0242ac130003"
    case icon60 = "5d5f849c-fc06-11eb-9a03-0242ac130003"
    case icon61 = "5d5f855a-fc06-11eb-9a03-0242ac130003"
    case icon62 = "5d5f8618-fc06-11eb-9a03-0242ac130003"
    case icon63 = "5d5f86cc-fc06-11eb-9a03-0242ac130003"
    case icon64 = "5d5f8780-fc06-11eb-9a03-0242ac130003"
    case icon65 = "5d5f8974-fc06-11eb-9a03-0242ac130003"
    case icon66 = "5d5f8a46-fc06-11eb-9a03-0242ac130003"
    case icon67 = "5d5f8afa-fc06-11eb-9a03-0242ac130003"
    case icon68 = "5d5f8bb8-fc06-11eb-9a03-0242ac130003"
    case icon69 = "5d5f8c6c-fc06-11eb-9a03-0242ac130003"
    case icon70 = "5d5f8d2a-fc06-11eb-9a03-0242ac130003"
    case icon71 = "5d5f8dde-fc06-11eb-9a03-0242ac130003"
    case icon72 = "5d5f9054-fc06-11eb-9a03-0242ac130003"
    case icon73 = "5d5f911c-fc06-11eb-9a03-0242ac130003"
    case icon74 = "5d5f91d0-fc06-11eb-9a03-0242ac130003"
    case icon75 = "5d5f9284-fc06-11eb-9a03-0242ac130003"
    case icon76 = "5d5f9338-fc06-11eb-9a03-0242ac130003"
    case icon77 = "5d5f93f6-fc06-11eb-9a03-0242ac130003"
    case icon78 = "5d5f94b4-fc06-11eb-9a03-0242ac130003"
    case icon79 = "5d5f9568-fc06-11eb-9a03-0242ac130003"
    case icon80 = "5d5f9798-fc06-11eb-9a03-0242ac130003"
    case icon81 = "5d5f9856-fc06-11eb-9a03-0242ac130003"
    case icon82 = "5d5f990a-fc06-11eb-9a03-0242ac130003"
    case icon83 = "5d5f99be-fc06-11eb-9a03-0242ac130003"
    case icon84 = "5d5f9a72-fc06-11eb-9a03-0242ac130003"
    case icon85 = "5d5f9b26-fc06-11eb-9a03-0242ac130003"
    case icon86 = "5d5f9be4-fc06-11eb-9a03-0242ac130003"
    case icon87 = "5d5f9f2c-fc06-11eb-9a03-0242ac130003"
    case icon88 = "5d5f9ffe-fc06-11eb-9a03-0242ac130003"
    case icon89 = "5d5fa0bc-fc06-11eb-9a03-0242ac130003"
}
