//
//  UserNotificationContainer.swift
//  macOS-SwiftUI
//
//  Created by Peter Vu on 4/14/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

import Combine
import Foundation
import UserNotifications

protocol NotificationKey: RawRepresentable where Self.RawValue == String {
    static var notificationKeyPrefix: String { get }
}

class UserNotificationContainer<Key: NotificationKey> {
    let notificationCenter: UNUserNotificationCenter
    private let prefix: String

    init(notificationCenter: UNUserNotificationCenter) {
        self.notificationCenter = notificationCenter
        self.prefix = Key.notificationKeyPrefix
    }

    func addRequest(with descriptor: UserNotificationDescriptor<Key>, resultHandler: ((Result<Void, Error>) -> Void)? = nil) {
        let newRequest = UNNotificationRequest(identifier: "\(prefix)|\(descriptor.key.rawValue)",
                                               content: descriptor.content,
                                               trigger: descriptor.trigger)
        notificationCenter.add(newRequest) { addError in
            if let error = addError {
                resultHandler?(.failure(error))
            } else {
                resultHandler?(.success(()))
            }
        }
    }

    func getPendingNotificationKeys(completionHandler: @escaping (([Key]) -> Void)) {
        let prefix = self.prefix
        notificationCenter.getPendingNotificationRequests { pendingRequests in
            let keys = pendingRequests
                .filter { $0.identifier.hasPrefix(prefix) }
                .flatMap { $0.identifier.split(separator: "|").dropFirst() }
                .map { String($0) }
                .compactMap { Key(rawValue: $0) }
            completionHandler(keys)
        }
    }

    func getPendingNotificationDescriptors(completionHandler: @escaping (([UserNotificationDescriptor<Key>]) -> Void)) {
        let prefix = self.prefix

        notificationCenter.getPendingNotificationRequests { pendingRequests in
            let descriptors = pendingRequests
                .filter { $0.identifier.hasPrefix(prefix) }
                .compactMap { request -> UserNotificationDescriptor<Key>? in
                    let keyRawValue = String(request.identifier.split(separator: "|").dropFirst().flatMap { $0 })
                    guard let key = Key(rawValue: keyRawValue),
                          let trigger = request.trigger
                    else { return nil }
                    return .init(key: key, content: request.content, trigger: trigger)
                }
            completionHandler(descriptors)
        }
    }

    func removePendingNotificationRequests(for keys: [Key]) {
        let targetKeys = keys.map { "\(prefix)|\($0.rawValue)" }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: targetKeys)
    }

    func removeAllPendingNotificationRequests(completionHandler: @escaping (() -> Void)) {
        getPendingNotificationKeys { keys in
            self.removePendingNotificationRequests(for: keys)
            completionHandler()
        }
    }

    func removeAllDeliveredNotifications(completionHandler: @escaping (() -> Void)) {
        let prefix = self.prefix
        notificationCenter.getDeliveredNotifications { notifications in
            let deliveredNotificationIds = notifications
                .filter({ $0.request.identifier.hasPrefix(prefix) })
                .map({ $0.request.identifier })
            self.notificationCenter.removeDeliveredNotifications(withIdentifiers: deliveredNotificationIds)
            completionHandler()
        }
    }

    func resolveNotification(_ notification: UNNotification) -> UserNotificationDescriptor<Key>? {
        let keyRawValue = String(notification.request.identifier.split(separator: "|").dropFirst().flatMap { $0 })
        guard let key = Key(rawValue: keyRawValue), let trigger = notification.request.trigger else {
            return nil
        }
        return .init(key: key, content: notification.request.content, trigger: trigger)
    }
}

struct UserNotificationDescriptor<Key: NotificationKey>: CustomStringConvertible {
    var key: Key
    var content: UNNotificationContent
    var trigger: UNNotificationTrigger

    var description: String {
        let nextTimeTrigger = (trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() ?? Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .long
        return "Next Time Trigger: \(formatter.string(from: nextTimeTrigger)) | Body: \(content.body)"
    }
}

extension UserNotificationContainer {
    func getPendingNotificationDescriptors() -> Future<[UserNotificationDescriptor<Key>], Never> {
        return .init { promise in
            self.getPendingNotificationDescriptors { promise(.success($0)) }
        }
    }

    func removeAllPendingNotificationRequests() -> Future<Void, Never> {
        return .init { promise in
            self.removeAllPendingNotificationRequests { promise(.success(())) }
        }
    }
}
