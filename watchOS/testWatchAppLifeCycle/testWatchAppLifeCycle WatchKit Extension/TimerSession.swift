//
//  TimerSession.swift
//  Habitify
//
//  Created by Peter Vu on 7/31/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

import Foundation

class TimerSession: NSObject, ObservableObject {
    let targetDuration: TimeInterval
    var passedDuration: TimeInterval {
        var totalActiveRangeDuration: TimeInterval = activeRanges.reduce(0, { $0 + $1.end.timeIntervalSince($1.start) })
        if let lastActiveTime = self.lastActiveTime {
            let now = Date()
            let lastActiveTimeInterval = now.timeIntervalSince(lastActiveTime)
            totalActiveRangeDuration += lastActiveTimeInterval
        }
        return min(targetDuration, totalActiveRangeDuration)
    }

    @objc dynamic private(set) var state: State = .idle
    private var lastActiveTime: Date?
    private var activeRanges: [DateInterval] = []
    private var didStart = false
    private(set) var startTime = Date()
    private(set) var context: [String: Any]?

    init(targetDuration: TimeInterval) {
        self.targetDuration = targetDuration
        super.init()
    }

    func start(withContext runningContext: [String: Any]? = nil) {
        guard !didStart else {
            return
        }
        didStart = true
        state = .running
        startTime = Date()
        lastActiveTime = startTime
        context = runningContext
        scheduleSessionCompleteNotification()
    }

    func pause() {
        state = .paused
        objectWillChange.send()
        pushActiveTimeRangeIfNeeded()
        removeSessionCompleteNotification()
    }

    func resume() {
        guard state == .paused else {
            return
        }
        state = .running
        objectWillChange.send()
        lastActiveTime = Date()
        scheduleSessionCompleteNotification()
    }

    func stop() {
        state = .stopped
        objectWillChange.send()
        pushActiveTimeRangeIfNeeded()
        removeSessionCompleteNotification()
    }

    private var sessionCompleteTimer: Timer?
    private func removeSessionCompleteNotification() {
        sessionCompleteTimer?.invalidate()
        sessionCompleteTimer = nil
    }

    private func scheduleSessionCompleteNotification() {
        guard sessionCompleteTimer == nil else {
            return
        }
        let remainingDuration = targetDuration - passedDuration
        sessionCompleteTimer = Timer
            .scheduledTimer(timeInterval: remainingDuration,
                            target: self,
                            selector: #selector(handleSessionComplete),
                            userInfo: nil,
                            repeats: false)
    }

    @objc
    private func handleSessionComplete() {
        state = .completed
        objectWillChange.send()
        pushActiveTimeRangeIfNeeded()
    }

    private func pushActiveTimeRangeIfNeeded() {
        guard let lastActiveTime = self.lastActiveTime else {
            return
        }
        let now = Date()
        let newActiveTimeRange = DateInterval(start: lastActiveTime, end: now)
        activeRanges.append(newActiveTimeRange)
        self.lastActiveTime = nil
    }
}

extension TimerSession {
    @objc
    enum State: Int {
        case running, paused, stopped, idle, completed
    }

    enum ContextKey: String {
        case habitID
        case habitName
        case loggedDuration
        case targetDuration
        case periodicityRaw
    }
}
