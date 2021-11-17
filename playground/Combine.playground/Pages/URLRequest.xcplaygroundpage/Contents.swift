//: [Previous](@previous)

import Foundation
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let p1: AnyPublisher<Int, Never> = [1, 3, 5].publisher.eraseToAnyPublisher()
let p2: AnyPublisher<Int, Never> = [2].publisher.eraseToAnyPublisher()
let p3: AnyPublisher<Int, Never> = Future<Int, Never>.init { promise in
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        promise(.success(10))
    }
}.eraseToAnyPublisher()

var cancellableSet = Set<AnyCancellable>()

func request() {
    [2].publisher
        .flatMap {
            Just($0)
        }
        .sink { v in
            print(v)
        }
        .store(in: &cancellableSet)
}

request()
print(cancellableSet)

request()
print(cancellableSet)

request()
print(cancellableSet)
