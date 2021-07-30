//
//  DurationPickerViewModel.swift
//  testWatchAppLifeCycle WatchKit Extension
//
//  Created by long vu unstatic on 7/28/21.
//

import Foundation
import Combine

class DurationPickerViewModel: ObservableObject {
    @Published var timerSessionViewModel: TimerSessionViewModel!
    
    func createTimerSessionViewModel(dateInterval: DateInterval) {
        let viewModel = TimerSessionViewModel(session: TimerSession(targetDuration: 60 * 5), context: [TimerSession.ContextKey.targetDuration.rawValue: dateInterval.duration])
        self.timerSessionViewModel = viewModel
    }
}
