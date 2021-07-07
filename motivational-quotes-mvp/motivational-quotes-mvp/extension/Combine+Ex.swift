//
//  Combine+Ex.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/29/21.
//

import Foundation
import Combine

extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<Root, Output>,
        onWeak object: Root
    ) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
