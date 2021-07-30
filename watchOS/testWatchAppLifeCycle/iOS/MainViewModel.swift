//
//  MainViewModel.swift
//  testWatchAppLifeCycle
//
//  Created by long vu unstatic on 7/28/21.
//

import Foundation
import Combine
import UserNotifications

class MainViewModel: ObservableObject {
    private let userNotificationCenter = UNUserNotificationCenter.current()
    init() {
    }
    
    func requestNotificationPermission() {
        userNotificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleTestNotification() {
        userNotificationCenter.removeAllPendingNotificationRequests()
        userNotificationCenter.removeAllDeliveredNotifications()
        let content = UNMutableNotificationContent()
        content.title = "Feed the cat"
        content.subtitle = "It looks hungry"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}
