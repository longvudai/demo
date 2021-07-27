import UIKit
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var greeting = "Hello, playground"

var disposeBag = Set<AnyCancellable>.init()

class MyObservable: ObservableObject {
    @Published var score: Int = 0
}

let object = MyObservable()
object.objectWillChange
    .sink {
        print("change")
    }
    .store(in: &disposeBag)

object.$score
    .sink { v in
        print(v)
    }
    .store(in: &disposeBag)

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    object.score = 2
}
