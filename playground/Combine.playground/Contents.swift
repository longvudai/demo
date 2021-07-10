import UIKit
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var greeting = "Hello, playground"

let testPublisher = CurrentValueSubject<Bool, Never>(false)

testPublisher.sink { value in
    print(value)
}

testPublisher.value = true
testPublisher.value = true
testPublisher.value = true
