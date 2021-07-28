//
//  TimerSessionViewModel.swift
//  testWatchAppLifeCycle WatchKit Extension
//
//  Created by long vu unstatic on 7/28/21.
//

import Foundation

class TimerSessionViewModel: ObservableObject {
    var dateInterval: DateInterval
    
    init(dateInterval: DateInterval) {
        self.dateInterval = dateInterval
    }
}
