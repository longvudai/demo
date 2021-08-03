//
//  TimerSessionManager.swift
//  Habitify
//
//  Created by Peter Vu on 7/16/19.
//  Copyright © 2020 Unstatic. All rights reserved.
//

import Foundation

class TimerSessionManager: NSObject {
    static let shared = TimerSessionManager()
    private override init() {
        super.init()
    }
    private let maximumOfRunningSessionCount: Int = 1
    private var sessions: [TimerSession] = []

    func newSession(forTargetDuration targetDuration: TimeInterval) throws -> TimerSession {
        let runningSessions = self.runningSessions()
        guard runningSessions.count < maximumOfRunningSessionCount else { throw Error.maximumRunningSessionReached }
        let newSession = TimerSession(targetDuration: targetDuration)
        sessions.append(newSession)
        return newSession
    }

    func runningSessions() -> [TimerSession] {
        return sessions.filter { $0.state == .running }
    }
}

extension TimerSessionManager {
    enum Error: Int, Swift.Error {
        case maximumRunningSessionReached
    }
}
