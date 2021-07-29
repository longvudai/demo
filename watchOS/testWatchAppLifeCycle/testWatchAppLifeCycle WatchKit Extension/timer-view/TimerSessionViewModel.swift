//
//  TimerSessionViewModel.swift
//  testWatchAppLifeCycle WatchKit Extension
//
//  Created by long vu unstatic on 7/28/21.
//

import Combine
import Foundation

class TimerSessionViewModel: ObservableObject {
    // MARK: - publisher properties
    @Published var progress: Double = 1
    @Published var countDownText: String?
    @Published var isCompleted: Bool = false
    
    // MARK: - private properties
    private var timerCancellable: AnyCancellable?
    private var cancellableSet = Set<AnyCancellable>()
    
    private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.allowsFractionalUnits = false
        formatter.zeroFormattingBehavior = DateComponentsFormatter.ZeroFormattingBehavior.pad
        return formatter
    }()

    var context: [String: Any] = [:]
    var session: TimerSession
    
//    private let initialDuration: TimeInterval
    private let targetDuration: TimeInterval
    private var passedDuration: TimeInterval = 0
    
    var habitName: String {
        return context[TimerSession.ContextKey.habitName.rawValue] as? String ?? "Read Book"
    }
    
    init(session: TimerSession, context: [String: Any]) {
        self.context = context
        self.session = session
        self.targetDuration = (context[TimerSession.ContextKey.targetDuration.rawValue] as? TimeInterval) ?? 0
//        self.passedDuration = (context[TimerSession.ContextKey.loggedDuration.rawValue] as? TimeInterval) ?? 0
//        self.initialDuration = passedDuration
        
        session.start()
        
        timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                self?.timerFired()
            })
        
        $isCompleted
            .removeDuplicates()
            .sink { [weak self] isCompleted in
                if isCompleted  {
                    print("finish")
                    self?.timerCancellable?.cancel()
//                    delegate?.timerSessionViewController(self, didComplete: session)
                }
            }
            .store(in: &cancellableSet)
    }
    
    func onDisappear() {
        timerCancellable = nil
    }
    
    private func timerFired() {
        let remainingDuration = targetDuration - passedDuration
        let remainingString = durationFormatter.string(from: remainingDuration)
        countDownText = remainingString
        passedDuration += 1
        
        if targetDuration != 0 {
            progress = max(0, 1 - Double(passedDuration / targetDuration))
        }
        print(progress)

        let isCompleted = remainingDuration <= 0
        if isCompleted {
            self.isCompleted = isCompleted
        }
    }
}

extension TimerSessionViewModel {
    static var mockedValue = TimerSessionViewModel(session: TimerSession(targetDuration: 5 * 60), context: [
        TimerSession.ContextKey.targetDuration.rawValue: TimeInterval(10),
        TimerSession.ContextKey.loggedDuration.rawValue: TimeInterval(60)
    ])
}
