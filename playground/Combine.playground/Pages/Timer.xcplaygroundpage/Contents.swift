import UIKit
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var cancellableSet: Set<AnyCancellable> = []

Timer.publish(every: 1, on: .main, in: .default)
    .autoconnect()
    .sink { v in
        print(v.timeIntervalSinceNow)
    }
    .store(in: &cancellableSet)
