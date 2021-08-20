//: [Previous](@previous)

import Foundation
import Combine

var cancellableSet: Set<AnyCancellable> = []
// MARK: - Subscribe on
let number = [1, 2, 3, 4, 5, 6].publisher
let serialQueue1 = DispatchQueue(label: "Serial Queue 1", qos: .userInteractive)
let serialQueue2 = DispatchQueue(label: "Serial Queue 2", qos: .background)

number
    .receive(on: DispatchQueue.global(qos: .background))
    .print(Thread.current.description)
    .sink { v in
        print("Received1 \(v) in \(Thread.current.description)")
        print("---")
    }
    .store(in: &cancellableSet)

print("X")

//number
//    .receive(on: serialQueue1)
////    .print(Thread.current.description)
//    .sink { v in
//        print("Received2 \(v) in \(Thread.current.debugDescription)")
//        print("---")
//    }
//    .store(in: &cancellableSet)


//: [Next](@next)
