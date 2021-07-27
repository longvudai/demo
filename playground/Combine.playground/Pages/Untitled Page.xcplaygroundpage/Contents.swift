import UIKit
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let source = ([nil] as [Int?]).publisher

let f = source.flatMap { v -> AnyPublisher<Int, Never> in
    if let i = v {
        return Just(i).eraseToAnyPublisher()
    } else {
        return Empty().eraseToAnyPublisher()
    }
}

enum MyError: Error {
    case testError
}
Empty<Any, MyError>().print().sink(receiveCompletion: { completion in
    switch completion {
    case .finished:
        print("finished")
    case .failure(let error):
        print("error", error)
    }
}) { value in
    print("value", value)
}
