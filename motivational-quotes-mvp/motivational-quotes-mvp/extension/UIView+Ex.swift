//
//  UIView+Ex.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/29/21.
//

import UIKit

public extension UIView {
    @available(iOS 10.0, *)
    func renderToImage(afterScreenUpdates: Bool = false) -> UIImage {
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.opaque = false
        let renderer = UIGraphicsImageRenderer(size: bounds.size, format: rendererFormat)

        let snapshotImage = renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        }
        return snapshotImage
    }
}
