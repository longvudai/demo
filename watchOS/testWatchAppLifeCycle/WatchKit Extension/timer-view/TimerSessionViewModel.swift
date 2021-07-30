//
//  TimerSessionViewModel.swift
//  testWatchAppLifeCycle WatchKit Extension
//
//  Created by long vu unstatic on 7/28/21.
//

import Combine
import Foundation
import RxSwift
import RxCocoa

class TimerSessionViewModel: ObservableObject {
    // MARK: - publisher properties
    @Published var progress: Double = 1
    @Published var countDownText: String?
    @Published var isCompleted: Bool = false
    @Published var controlButtonTitle: String = "Start"
    
    private var action = CurrentValueSubject<Action, Never>(.start)
    
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
    
    private let targetDuration: TimeInterval
    private var passedDuration: TimeInterval = 0
    
    var habitName: String {
        return context[TimerSession.ContextKey.habitName.rawValue] as? String ?? "Read Book"
    }
    
    init(session: TimerSession, context: [String: Any]) {
        self.context = context
        self.session = session
        self.targetDuration = (context[TimerSession.ContextKey.targetDuration.rawValue] as? TimeInterval) ?? 0
        
        self.countDownText = durationFormatter.string(from: targetDuration)
        
        let state = session
            .publisher(for: \.state)
            .share()
        
        state
            .map { [weak self] state -> Action in
                self?.action(for: state) ?? .start
            }
            .assign(to: \.value, on: action)
            .store(in: &cancellableSet)

        action
            .removeDuplicates()
            .map { $0.localizedTitle }
            .weakAssign(to: \.controlButtonTitle, on: self)
            .store(in: &cancellableSet)
            
        let tick = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
        
        tick
            .combineLatest(state, $isCompleted, { _, state, isCompleted in
                return (state, isCompleted)
            })
            .filter { !$0.1 }
            .map { $0.0 }
            .filter { $0 ~= TimerSession.State.running }
            .sink(receiveValue: { [weak self] _ in
                self?.timerFired()
            })
            .store(in: &cancellableSet)
        
        $isCompleted
            .sink { [weak self] isCompleted in
                if isCompleted  {
                    self?.timerCancellable?.cancel()
//                    delegate?.timerSessionViewController(self, didComplete: session)
                }
            }
            .store(in: &cancellableSet)
        
        $controlButtonTitle.sink { v in
            print(v)
        }.store(in: &cancellableSet)
        
        session.start()
    }
    
    func onDisappear() {
        timerCancellable = nil
    }
    
    func controlButtonTapped() {
        switch action.value {
        case .pause:
            session.pause()

        case .resume:
            session.resume()

        case .stop:
            session.stop()

        case .start:
            session.start()
        }
    }
    
    // MARK: - helper
    private func timerFired() {
        let remainingDuration = targetDuration - passedDuration
        let remainingString = durationFormatter.string(from: remainingDuration)
        countDownText = remainingString
        passedDuration += 1
        
        if targetDuration != 0 {
            progress = max(0, 1 - Double(passedDuration / targetDuration))
        }

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

private extension TimerSessionViewModel {
    // FIXME: remove mocked L10 enum
    enum L10n {
        struct Common {
            static let start = "start"
            static let pause = "pause"
            static let resume = "resume"
            static let stop = "stop"
        }
    }
    
    enum Action {
        case start, pause, resume, stop

        var localizedTitle: String {
            switch self {
            case .start:
                return L10n.Common.start
            case .pause:
                return L10n.Common.pause
            case .resume:
                return L10n.Common.resume
            case .stop:
                return L10n.Common.stop
            }
        }
    }

    func action(for state: TimerSession.State) -> Action {
        switch state {
        case .idle:
            return.start

        case .paused:
            return.resume

        case .completed:
            return.start

        case .running:
            return.pause

        case .stopped:
            return.resume
        }
    }
}

