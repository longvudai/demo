import UIKit
import Foundation
import PlaygroundSupport
import Combine

//PlaygroundPage.current.needsIndefiniteExecution = true
let numbers = [1, 2, 3,4, 5,6 ,71, 72, 8]

extension Collection where Index == Int {
    func chunked(by chunkSize: Int) -> [[Element]] {
        stride(from: startIndex, to: endIndex, by: chunkSize).map { Array(self[$0..<Swift.min($0 + chunkSize, count)]) }
    }
}

numbers.chunked(by: 2)

let a = Set([1, 2])
let b = Set([2, 1])

a == b

pow(2, 3)
