//
//  WatchTimerSessionPlugin.swift
//  testWatchAppLifeCycle WatchKit Extension
//
//  Created by long vu unstatic on 7/30/21.
//

import Foundation
import UserNotifications

final class WatchTimerSessionNotificationPlugin: NSObject, UserNotificationPlugin {
    var context: UserNotificationContext?

    func applicationWillResignActive() {
        guard let currentSession = TimerSessionManager.shared.runningSessions().first,
            let habitName = currentSession.context?[TimerSession.ContextKey.habitName.rawValue] as? String,
            let container = context?.container(for: NotificationKeys.self) else {
            return
        }
        
        currentSession.pause()
    }

    private func removeAllPendingTimerNotifications() {
        context?.container(for: NotificationKeys.self).removeAllPendingNotificationRequests(completionHandler: {})
    }

    private func removeAllDeliveredTimerNotifications() {
        context?.container(for: NotificationKeys.self).removeAllDeliveredNotifications(completionHandler: {})
    }

    func applicationDidBecomeActive() {
        removeAllPendingTimerNotifications()
        removeAllDeliveredTimerNotifications()
    }

    func applicationDidFinishLaunching() {
        removeAllDeliveredTimerNotifications()
    }

    func applicationWillTerminate() {
        removeAllPendingTimerNotifications()
        postTimerCancelledNotificationIfNeeded()
    }

    func applicationDidEnterBackground() {
    }

    func didReceiveResponse(_ response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    private func postTimerCancelledNotificationIfNeeded() {
        guard let currentSession = TimerSessionManager.shared.runningSessions().first,
            let habitName = currentSession.context?[TimerSession.ContextKey.habitName.rawValue] as? String,
            let container = context?.container(for: NotificationKeys.self)  else {
            return
        }

        let cancelledNotificationContent = UNMutableNotificationContent()
        cancelledNotificationContent.title = "L10n.Notification.timerCancelledTitle"
        cancelledNotificationContent.body = "L10n.Notification.timerCancelledBody(habitName)"
        let cancelledNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        container.addRequest(with: .init(key: .timerCancelled,
                                         content: cancelledNotificationContent,
                                         trigger: cancelledNotificationTrigger))
    }
}

private extension WatchTimerSessionNotificationPlugin {
    enum NotificationKeys: String, NotificationKey {
        static let notificationKeyPrefix: String = "timer-session-plugin"
        case runningTimer = "timer-session-running-timer"
        case timerCompleted = "timer-completed"
        case timerCancelled = "timer-cancelled"
    }
}
