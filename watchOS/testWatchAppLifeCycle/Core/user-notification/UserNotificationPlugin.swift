//
//  UserNotificationPlugin.swift
//  macOS-SwiftUI
//
//  Created by Peter Vu on 4/14/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

import Foundation
import UserNotifications

protocol UserNotificationPlugin: UNUserNotificationCenterDelegate {
    var context: UserNotificationContext? { get set }

    func applicationWillResignActive()
    func applicationDidBecomeActive()
    func applicationDidFinishLaunching()
    func applicationWillTerminate()
    func applicationDidEnterBackground()

    func didReceiveResponse(_ response: UNNotificationResponse,
                            withCompletionHandler completionHandler: @escaping () -> Void)

    func willPresent(notification: UNNotification,
                     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
}

extension UserNotificationPlugin {
    func applicationWillResignActive() { }
    func applicationDidBecomeActive() { }
    func applicationDidFinishLaunching() { }
    func applicationWillTerminate() { }
    func applicationDidEnterBackground() { }

    func didReceiveResponse(_ response: UNNotificationResponse,
                            withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func willPresent(notification: UNNotification,
                     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([])
    }
}
