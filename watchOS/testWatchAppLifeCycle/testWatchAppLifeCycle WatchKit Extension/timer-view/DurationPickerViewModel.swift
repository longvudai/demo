//
//  DurationPickerViewModel.swift
//  testWatchAppLifeCycle WatchKit Extension
//
//  Created by long vu unstatic on 7/28/21.
//

import Foundation
import Combine

class DurationPickerViewModel: ObservableObject {
    private var timerSessionViewModel: TimerSessionViewModel?
    func createTimerSessionViewModel(dateInterval: DateInterval) -> TimerSessionViewModel {
        let viewModel = TimerSessionViewModel(dateInterval: dateInterval)
        self.timerSessionViewModel = viewModel
        return viewModel
    }
}
