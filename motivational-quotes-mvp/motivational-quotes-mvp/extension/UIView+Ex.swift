//
//  UIView+Ex.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/29/21.
//

import UIKit

public extension UIView {
    @available(iOS 10.0, *)
    func renderToImage(afterScreenUpdates: Bool = false, size: CGSize) -> UIImage {
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.opaque = false
        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)

        
        let snapshotImage = renderer.image { _ in
            drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: afterScreenUpdates)
        }
        return snapshotImage
    }
}
