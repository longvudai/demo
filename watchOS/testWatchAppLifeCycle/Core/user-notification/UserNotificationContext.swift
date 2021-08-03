//
//  UserNotificationContext.swift
//  macOS-SwiftUI
//
//  Created by Peter Vu on 4/14/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

import Foundation
import UserNotifications

protocol UserNotificationContext {
    var calendar: Calendar { get }
    var referenceDate: Date { get }
    func container<Key: NotificationKey>(for keyType: Key.Type) -> UserNotificationContainer<Key>
}

struct AnyUserNotificationContext: UserNotificationContext {
    var notificationCenter: UNUserNotificationCenter
    var calendar: Calendar
    var referenceDate: Date

    func container<Key>(for keyType: Key.Type) -> UserNotificationContainer<Key> where Key: NotificationKey {
        return .init(notificationCenter: notificationCenter)
    }
}
