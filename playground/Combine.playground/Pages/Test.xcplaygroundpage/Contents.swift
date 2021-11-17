import UIKit
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var cancellableSet: Set<AnyCancellable> = []

let number = CurrentValueSubject<Int?, Never>.init(1)
number
    .filter { $0 == nil }
    .sink { v in
    print(v)
}
    .store(in: &cancellableSet)

number.send(13)

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    number
        .sink { v in
        print("2", v)
    }.store(in: &cancellableSet)
}
