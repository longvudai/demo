//
//  Defines.swift
//  Habitify SwiftUI
//
//  Created by Peter on 8/21/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

import Foundation
import SwiftUI

#if os(watchOS) || os(iOS)
typealias PlatformColor = UIColor
typealias PlatformImage = UIImage
typealias PlatformSize = CGSize
typealias PlatformFont = UIFont
#endif

#if os(iOS)
import UIKit
typealias ViewRepresentable = UIViewRepresentable
typealias PlatformView = UIView
typealias PlatformFontMetrics = UIFontMetrics

#elseif os(macOS)
import AppKit
typealias PlatformImage = NSImage
typealias PlatformColor = NSColor
typealias ViewRepresentable = NSViewRepresentable
typealias PlatformView = NSView
typealias PlatformSize = NSSize
typealias PlatformFont = NSFont
typealias PlatformFontMetrics = FontMetrics

extension PlatformImage {
    convenience init?(systemName: String) {
        self.init(named: systemName)
    }
}

struct FontMetrics {
    static let `default` = FontMetrics()
    private init() { }

    func scaledValue(for value: CGFloat) -> CGFloat {
        return value
    }
}
#endif

extension Image {
    init?(platformImage: PlatformImage) {
        #if os(iOS) || os(watchOS)
        self.init(uiImage: platformImage)
        #elseif os(macOS)
        self.init(nsImage: platformImage)
        #endif
    }
}

extension PlatformColor {
    static func with(lightColor: PlatformColor, darkColor: PlatformColor) -> PlatformColor {
        #if os(macOS)
        return PlatformColor(name: nil) { appearance -> PlatformColor in
            guard let appearanceNamed = appearance.bestMatch(from: [.darkAqua, .aqua]) else {
                return lightColor
            }

            switch appearanceNamed {
            case .darkAqua:
                return darkColor

            case .aqua:
                return lightColor

            default:
                return lightColor
            }
        }
        #elseif os(iOS)
        return PlatformColor(dynamicProvider: { traitCollection -> PlatformColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return darkColor

            case .light, .unspecified:
                return lightColor
            @unknown default:
                return lightColor
            }
        })
        #elseif os(watchOS)
        return darkColor
        #endif
    }
}
