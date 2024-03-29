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
        let targetDuration = dateInterval.duration
        let viewModel = TimerSessionViewModel(session: TimerSession(targetDuration: targetDuration), context: [:])
        self.timerSessionViewModel = viewModel
    }
}
