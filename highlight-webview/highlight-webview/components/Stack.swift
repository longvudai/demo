//
//  Stack.swift
//  highlight-webview
//
//  Created by Long Vu on 11/12/2020.
//

import Foundation

public struct Stack<T> {
    fileprivate var array = [T]()

    public var isEmpty: Bool {
        return array.isEmpty
    }

    public var count: Int {
        return array.count
    }

    public mutating func push(_ element: T) {
        array.append(element)
    }

    public mutating func pop() -> T? {
        return array.popLast()
    }
  
    public var top: T? {
        return array.last
    }
    
    public mutating func removeFirst() -> T? {
        return array.removeFirst()
    }
}

extension Stack: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var curr = self
        return AnyIterator {
          return curr.pop()
        }
    }
}
