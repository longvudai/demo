import UIKit
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var cancellableSet: Set<AnyCancellable> = []

//let future = Future<Int, Never> { promise in
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//        let sum = (0...1000).reduce(0, +)
//        promise(.success(sum))
//    }
//}
//
//future
//    .receive(on: DispatchQueue.main)
//    .sink { sum in
//        print("sum", sum)
//    }
//    .store(in: &cancellableSet)

let subject: PassthroughSubject<[Int], Never> = .init()

subject
    .map { ints -> [AnyPublisher<Int, Never>] in
        let result: [AnyPublisher<Int, Never>] = ints.map { value in
            return [value, value + 1].publisher
//                .prefix(1)
                .eraseToAnyPublisher()
        }
        return result
    }
    .flatMap { streams in
        return Publishers.MergeMany(streams)
            .collect()
            .eraseToAnyPublisher()
    }
    .receive(on: DispatchQueue.main)
    .sink { v in
        print("value", v)
    }
    .store(in: &cancellableSet)


subject.send([1, 2])
subject.send([1, 2, 3])
