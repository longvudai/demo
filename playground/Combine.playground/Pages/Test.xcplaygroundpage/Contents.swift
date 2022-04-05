import UIKit
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var cancellableSet: Set<AnyCancellable> = []

let future = Future<Int, Never> { promise in
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        let sum = (0...1000).reduce(0, +)
        promise(.success(sum))
    }
}

//future
//    .receive(on: DispatchQueue.main)
//    .sink { sum in
//        print("sum", sum)
//    }
//    .store(in: &cancellableSet)
