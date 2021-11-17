//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import Combine
import UIKit

PlaygroundPage.current.needsIndefiniteExecution = true

var cancellableSet = Set<AnyCancellable>()

func makeP1() -> AnyPublisher<Int, Never> {
    return Timer.publish(every: 1, on: .main, in: .default)
        .autoconnect()
        .map { _ in Int.random(in: 4...10) }
        .eraseToAnyPublisher()
    
}

let p1 = makeP1()
//    .share()
//    .shareReplay(1)
    .print("p1")

p1
    .handleEvents(receiveOutput: { v in
        print("event", v)
    })
    .sink { v in
        print("s1", v)
}
.store(in: &cancellableSet)
//
//DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//    // your code here
//    p1.sink { v in
//        print("s2", v)
//    }
//    .store(in: &cancellableSet)
//}




