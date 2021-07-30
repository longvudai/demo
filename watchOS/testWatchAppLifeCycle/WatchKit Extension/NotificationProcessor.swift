//
//  NotificationProcessor.swift
//  NotificationDemo
//
//  Created by Eric Blair on 1/17/17.
//  Copyright © 2017 Martiancraft. All rights reserved.
//

import WatchKit
import UserNotifications

/// The Notification Processor handles the details of updating the application status for recevied and processed notifications
/// Handling the logic in a dedicate class / `UNUserNotificationCenterDelegate` instance avoids the scenario of notifications
/// coming in before any Interface Controllers are loaded/
class NotificationProcessor: NSObject {
    private let center = UNUserNotificationCenter.current()
    /// Connectivity Manager for communicating with host app
//    let connectivityManager: ConnectivityManager?
    
//    init(connectivityManager: ConnectivityManager? = nil) {
//        self.connectivityManager = connectivityManager
//
//        super.init()
//    }
    
    /// Registers for known notification categories.
	///
	/// - Note: These notification categories and actions **only** apply to notifications schedules on-Watch.
    func registerNotifications() {
        center.getNotificationSettings { [weak self] setting in
            print("NotificationSetting:", String(describing: setting.authorizationStatus.rawValue))
            guard setting.authorizationStatus == .notDetermined else {
                print("not request")
                return
            }
            
            self?.center.requestAuthorization(options: [.alert, .sound]) { registered, _ in
                guard registered else {
                    print ("Failed to request notification authorization")
                    return
                }
                
                DispatchQueue.main.async {
                    WKExtension.shared().registerForRemoteNotifications()
                }
            }
            
        }
//		let modalAction = UNNotificationAction(
//			identifier: UserNotificationAction.modal.rawValue,
//			title: NSLocalizedString("Local Modal", comment: "Modal notification title"),
//			options: [.foreground])
//
//		let modalTextAction = UNTextInputNotificationAction(
//			identifier: UserNotificationAction.textInput.rawValue,
//			title: NSLocalizedString("Text Input", comment: "Text input notificatoin title"),
//			options: [.foreground],
//			textInputButtonTitle: NSLocalizedString("Say something", comment: "Text input title button title"),
//			textInputPlaceholder: NSLocalizedString("Content here", comment: "Text input placeholder"))
//
//        let primaryCategory = UNNotificationCategory(
//			identifier: UserNotificationCategory.primaryMode.rawValue,
//			actions: [modalAction, modalTextAction],
//			intentIdentifiers: [],
//			options: [])
//
//        let repeatingCategory = UNNotificationCategory(
//			identifier: UserNotificationCategory.repeating.rawValue,
//			actions: [],
//			intentIdentifiers: [],
//			options: .customDismissAction)
//
//        let categories: Set<UNNotificationCategory> = [primaryCategory, repeatingCategory]
//
//        UNUserNotificationCenter.current().setNotificationCategories(categories)
    }
    
    /// Updates the application state with the given notification
    ///
    /// - Parameters:
    ///   - notification: The notification being processed
    ///   - action: The action, if any, associated with the notification
    fileprivate func process(notification: UNNotification, with response: UNNotificationResponse? = nil) {
//		let actionIdentifier = response?.actionIdentifier
//        guard actionIdentifier != UNNotificationDismissActionIdentifier else {
//            self.clearRepeatingNotifications()
//            return
//        }
//
//		let action = actionIdentifier.flatMap { UserNotificationAction(rawValue: $0) }
//		let notificationInfo = NotificationInfo(notification: notification, response: response)
//
//        // openSystemURL seems particularly flaky when being invoked around the same time as resuming the app or displaying an interface controller.
//        // The app appears to be blocked until the app is switched out of the foreground
//        // Handling the openSystemURL call here separates out the request from the the interface controller reloading.
//        // The asyncAfter gives the call some breathing room from the app activation
//        if UserNotificationCategory(rawValue: notification.request.content.categoryIdentifier) == .primaryMode && action == .call {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
//                if let phoneNumberURL = URL(string: "tel:8675309") {
//                    WKExtension.shared().openSystemURL(phoneNumberURL)
//                }
//            }
//        } else if let notificationController = WKExtension.shared().rootInterfaceController as? NotificationHandleable,
//            notificationController.canHandle(notification: notification, with: response) {
//            // We should be able to display a modal over an existing interface controller without needing to track state
//            // Alternatively, we could implement a `canHandle` method on the InterfaceController (or declare it in a protocol)
//            // to encapsulate the notification handling logic.
//            notificationController.handle(notification: notification, with: response)
//        } else {
//            // Reloading the root interface controller is a bit heavy-handed. However, the constraints imposed by WatchKit on
//            // inspecting the current interface hierarchy mean we'd be doing a fair bit of book-keeping on the application state
//            // to figure out if we needed to push or pop controllers from the view hierarchy.
//            // Such an approach may not be necessary for non-hierarchical interfaces (page based or single-screen), but those paradigms
//            // still have to account for the UI not yet being loaded at the time the notification is received.
//            WKInterfaceController.reloadRootControllers(withNames: [InterfaceController.identifer], contexts: [notificationInfo])
//        }
    }
}

extension NotificationProcessor: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		
        completionHandler([.sound, .alert])
//        guard WKExtension.shared().applicationState != .background else {
//            completionHandler([.sound, .alert])
//            return
//        }
        
//        let presentationOptions: UNNotificationPresentationOptions
//        if let rawMode = UserDefaults.standard.string(forKey: CurrentModeKey), Mode(rawValue: rawMode) == .secondary
//            || UserNotificationCategory(rawValue: notification.request.content.categoryIdentifier) == .repeating
//			|| !notification.request.content.attachments.isEmpty {
//            presentationOptions = [.sound, .alert]
//        } else {
//            presentationOptions = []
//        }
//
//        completionHandler(presentationOptions)
//
//        if !presentationOptions.contains(.alert) {
//            // Non-Watch notifications that are processed without displaying the notification will remain in the notification center.
//            // Since they are technically delivered to the iOS device, we need to ask the iOS device to remove the notification.
//            // This only applies to notification that are delivered to the iOS device, not local notifications scheduled on the watch.
//            // We could check the notification IDs against delivered IDs in the user notification center, but calling this with a
//            // Watch notification doesn't really hurt anything
//            self.connectivityManager?.send(message: ClearNotificationCommand(identifier: notification.request.identifier))
//
//            self.process(notification: notification)
//        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // When a custom interface is defined and the notification body is tapped, this method appears to be called twice.
        // Once with the UNNotificationDefaultActionIdentifier action and once with an empty string for the action.
        // Filter out the empty string call to prevent duplicate notification processing.
        // Apparently fixed in watchOS 3.1.3
        guard !response.actionIdentifier.isEmpty else { return }
		
		print("Notification Category: \(response.notification.request.content.categoryIdentifier)")
		print("Action Identifier: \(response.actionIdentifier)");
        print("\(#function) - action = \(response.actionIdentifier) (\(response.actionIdentifier.count))")
        self.process(notification: response.notification, with: response)
        
        completionHandler()
    }
}

/// Structure that wraps the required info for reacting to a notification response
struct NotificationInfo {
//    /// The notification that triggered the response
//    let notification: UNNotification
//	/// The notification response
//	let response: UNNotificationResponse?
//
//	/// The action in the response
//	var action: UserNotificationAction? {
//		return response.flatMap { UserNotificationAction(rawValue: $0.actionIdentifier ) }
//	}
}
