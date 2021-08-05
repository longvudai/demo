//
//  AppStyle.swift
//  Habitify SwiftUI
//
//  Created by Peter Vu on 6/24/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import SwiftUI

// swiftlint:disable force_unwrapping
// Color optional
enum Colors {
    static private(set) var labelPrimary = PlatformColor(named: "Label Primary")!
    static private(set) var labelSecondary = PlatformColor(named: "Label Secondary")!
    static private(set) var accentPrimary = PlatformColor(named: "Accent Primary")!

    #if os(iOS)
    static private(set) var background: PlatformColor = {
        return .init { traitCollection -> PlatformColor in
            switch traitCollection.userInterfaceLevel {
            case .base, .unspecified:
                return UIColor(named: "Background")!

            case .elevated:
                return UIColor(named: "Background Elevated")!
            @unknown default:
                return UIColor(named: "Background")!
            }
        }
    }()
    #endif

    static private(set) var secondaryBackground = PlatformColor(named: "Secondary Background")!
    static private(set) var groupedBackground = PlatformColor(named: "Grouped Background")!
    static private(set) var groupedSecondaryBackground = PlatformColor(named: "Grouped Secondary Background")!
    static private(set) var groupedTertiaryBackground = PlatformColor(named: "Grouped Tertiary Background")!

    static private(set) var buttonSecondaryForeground = PlatformColor(named: "Secondary Button Foreground")!
    static private(set) var buttonPrimaryForeground = PlatformColor(named: "Primary Button Foreground")!

    static private(set) var separator = PlatformColor(named: "Separator")!
    static private(set) var skipBackground = PlatformColor(named: "Skip Background")!
    static private(set) var failBackground = PlatformColor(named: "Fail Background")!
    static private(set) var error = PlatformColor(named: "Error")!
    static private(set) var trendUp = PlatformColor(named: "Trend Up")!
    static private(set) var trendDown = PlatformColor(named: "Trend Down")!

    static private(set) var sidebarUnselected  = PlatformColor(named: "Sidebar Unselected")!

    #if os(macOS)
    static private(set) var background = PlatformColor(named: "Background")!
    static private(set) var sidebarBadge = PlatformColor(named: "Sidebar Badge Background")!
    static private(set) var sidebarBadgeSelected = PlatformColor(named: "Sidebar Badge Background Selected")!
    static private(set) var appleSignInButtonBackground = PlatformColor(named: "Apple Sign In Button Background")!
    static private(set) var appleSignInButtonForeground = PlatformColor(named: "Apple Sign In Button Foreground")!
    static private(set) var sidebarSelected = PlatformColor(named: "Sidebar Selected")!
    #endif
}

extension Color {
    static private(set) var labelPrimary = Color(Colors.labelPrimary)
    static private(set) var labelSecondary = Color(Colors.labelSecondary)
    static private(set) var accentPrimary = Color(Colors.accentPrimary)
    #if !os(watchOS)
    static private(set) var background = Color(Colors.background)
    #endif
    static private(set) var secondaryBackground = Color(Colors.secondaryBackground)

    static private(set) var groupedBackground = Color(Colors.groupedBackground)
    static private(set) var groupedSecondaryBackground = Color(Colors.groupedSecondaryBackground)
    static private(set) var groupedTertiaryBackground = Color(Colors.groupedTertiaryBackground)

    static private(set) var buttonPrimaryForeground = Color(Colors.buttonPrimaryForeground)
    static private(set) var buttonSecondaryForeground = Color(Colors.buttonSecondaryForeground)

    static private(set) var separator = Color(Colors.separator)
    static private(set) var skipBackground = Color(Colors.skipBackground)
    static private(set) var failBackground = Color(Colors.failBackground)
    static private(set) var error = Color(Colors.error)
    static private(set) var trendUp = Color(Colors.trendUp)
    static private(set) var trendDown = Color(Colors.trendDown)

    #if os(macOS)
    static private(set) var sidebarSelected = Color(Colors.sidebarSelected)
    static private(set) var sidebarBadge = Color(Colors.sidebarBadge)
    static private(set) var sidebarBadgeSelected = Color(Colors.sidebarBadgeSelected)
    static private(set) var appleSignInButtonBackground = Color(Colors.appleSignInButtonBackground)
    static private(set) var appleSignInButtonForeground = Color(Colors.appleSignInButtonForeground)
    #endif
}

extension PlatformColor {
    convenience init?(hexRGBA: String?) {
        guard let rgba = hexRGBA, let val = Int(rgba.replacingOccurrences(of: "#", with: ""), radix: 16) else {
            return nil
        }
        self.init(red: CGFloat((val >> 24) & 0xff) / 255.0, green: CGFloat((val >> 16) & 0xff) / 255.0, blue: CGFloat((val >> 8) & 0xff) / 255.0, alpha: CGFloat(val & 0xff) / 255.0)
    }

    convenience init?(hexRGB: String?) {
        guard let rgb = hexRGB else {
            return nil
        }
        self.init(hexRGBA: rgb + "ff") // Add alpha = 1.0
    }
}

extension PlatformColor {
    var hexString: String? {
        guard let components = cgColor.components, components.count >= 3 else {
                return nil
            }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        /*
        if includesAlphaChannel {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }*/
    }
}
