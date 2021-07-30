//
//  WeakAssign.swift
//
//  Created by Peter Vu on 11/2/19.
//  Copyright © 2020 Unstatic. All rights reserved.
//

import Combine
import CombineExt
import RxCombine

extension Publisher where Self.Failure == Never {
    /// Assigns each element from a Publisher to a property on an object.
    ///
    /// - Parameters:
    ///   - keyPath: The key path of the property to assign.
    ///   - object: The object on which to assign the value.
    /// - Returns: A cancellable instance; used when you end assignment
    ///   of the received value. Deallocation of the result will tear down
    ///   the subscription stream.
    public func weakAssign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>,
                                            on object: Root) -> AnyCancellable {
        return assign(to: keyPath, on: object, ownership: .weak)
    }
}

public extension Publisher where Self.Failure == Never {
    func flatMapLatestLegacy<P: Publisher>(_ transform: @escaping (Output) -> P) -> AnyPublisher<P.Output, P.Failure> where P.Failure == Self.Failure {
        if #available(iOS 13.4, watchOS 6.0, *) {
            return map(transform).switchToLatest().eraseToAnyPublisher()
        } else {
            return self
                    .asObservable()
                    .flatMapLatest({ transform($0).asObservable() })
                    .asPublisher()
                    .assertNoFailure()
                    .eraseToAnyPublisher()
        }
    }
}
