//
//  View+Extension.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/21/21.
//

import Foundation
import UIKit

extension UIView {
    static func preventDimmingView() {
        guard let originalMethod = class_getInstanceMethod(UIView.self, #selector(addSubview(_:))), let swizzledMethod = class_getInstanceMethod(UIView.self, #selector(swizzled_addSubview(_:))) else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    static func allowDimmingView() {
        guard let originalMethod = class_getInstanceMethod(UIView.self, #selector(addSubview(_:))), let swizzledMethod = class_getInstanceMethod(UIView.self, #selector(swizzled_addSubview(_:))) else { return }
        method_exchangeImplementations(swizzledMethod, originalMethod)
    }

    @objc func swizzled_addSubview(_ view: UIView) {
        let className = "_UIParallaxDimmingView"
        guard let offendingClass = NSClassFromString(className) else { return swizzled_addSubview(view) }
        if (view.isMember(of: offendingClass)) {
            return
        }
        swizzled_addSubview(view)
    }
}
