//
//  RoundedCorner.swift
//  macOS-SwiftUI
//
//  Created by Peter Vu on 4/7/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: RectCorner

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        // Make sure we do not exceed the size of the rectangle
        let tr: CGFloat = corners.contains(.topRight) ? min(min(radius, h / 2), w / 2) : 0
        let tl: CGFloat = corners.contains(.topLeft) ? min(min(radius, h / 2), w / 2) : 0
        let bl: CGFloat = corners.contains(.bottomLeft) ? min(min(radius, h / 2), w / 2) : 0
        let br: CGFloat = corners.contains(.bottomRight) ? min(min(radius, h / 2), w / 2) : 0

        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr),
                    radius: tr,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)

        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br),
                    radius: br,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)

        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl),
                    radius: bl,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)

        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl),
                    radius: tl,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)

        return path
    }
}

struct RectCorner: OptionSet {
    var rawValue: Int

    static let topLeft: Self = .init(rawValue: 1 << 0)
    static let topRight: Self = .init(rawValue: 1 << 1)
    static let bottomLeft: Self = .init(rawValue: 1 << 2)
    static let bottomRight: Self = .init(rawValue: 1 << 3)
    static let allCorners: Self = [.topLeft, .topRight, .bottomLeft, .bottomRight]
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: RectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
