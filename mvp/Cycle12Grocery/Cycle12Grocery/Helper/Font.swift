//
//  Font.swift
//  Habitify
//
//  Created by long vu unstatic on 6/30/21.
//  Copyright © 2021 Peter Vu. All rights reserved.
//

import Foundation
import SwiftUI
import TextAttributes
import UIKit

enum AppTextStyles {
    static let heading1 = TextAttributes()
        .font(Self.defaultFont(size: 30, weight: .bold))
        .foregroundColor(Colors.labelPrimary)

    static let heading2 = TextAttributes()
        .font(Self.defaultFont(size: 26, weight: .bold))
        .foregroundColor(Colors.labelPrimary)

    static let heading3 = TextAttributes()
        .font(Self.defaultFont(size: 22, weight: .semibold))
        .foregroundColor(Colors.labelPrimary)

    static let heading4 = TextAttributes()
        .font(Self.defaultFont(size: 20, weight: .semibold))
        .foregroundColor(Colors.labelPrimary)

    static let heading5 = TextAttributes()
        .font(Self.defaultFont(size: 18, weight: .semibold))
        .foregroundColor(Colors.labelPrimary)

    static let heading6 = TextAttributes()
        .font(Self.defaultFont(size: 16, weight: .medium))
        .foregroundColor(Colors.labelPrimary)

    static let caption1 = TextAttributes()
        .font(Self.defaultFont(size: 13, weight: .medium))
        .foregroundColor(Colors.labelSecondary)

    static let caption2 = TextAttributes()
        .font(Self.defaultFont(size: 11, weight: .semibold))
        .foregroundColor(Colors.labelSecondary)

    static let subHeading = TextAttributes()
        .font(Self.defaultFont(size: 16, weight: .regular))
        .foregroundColor(Colors.labelSecondary)

    static let body = TextAttributes()
        .font(Self.defaultFont(size: 16, weight: .regular))
        .foregroundColor(Colors.labelPrimary)
        .lineSpacing(6)

    static let footnote = TextAttributes()
        .font(Self.defaultFont(size: 13, weight: .regular))
        .foregroundColor(Colors.labelSecondary)

    static let chartEntryLabel = TextAttributes()
        .font(Self.defaultFont(size: 10, weight: .medium))
        .foregroundColor(Colors.labelSecondary)
    static let title1 = TextAttributes()
        .font(Self.defaultFont(size: 20, weight: .medium))
        .foregroundColor(Colors.labelPrimary)
    static let subtitle1 = TextAttributes()
        .font(Self.defaultFont(size: 16, weight: .regular))
        .foregroundColor(Colors.labelSecondary)

    static let title2 = TextAttributes()
        .font(Self.defaultFont(size: 18, weight: .medium))
        .foregroundColor(Colors.labelPrimary)
    static let subtitle2 = TextAttributes()
        .font(Self.defaultFont(size: 16, weight: .regular))
        .foregroundColor(Colors.labelSecondary)

    static let title3 = TextAttributes()
        .font(Self.defaultFont(size: 16, weight: .medium))
        .foregroundColor(Colors.labelPrimary)
    static let subtitle3 = TextAttributes()
        .font(Self.defaultFont(size: 14, weight: .regular))
        .foregroundColor(Colors.labelSecondary)

    static let title4 = TextAttributes()
        .font(Self.defaultFont(size: 14, weight: .medium))
        .foregroundColor(Colors.labelPrimary)

    static let subtitle4 = TextAttributes()
        .font(Self.defaultFont(size: 13, weight: .regular))
        .foregroundColor(Colors.labelSecondary)

    static let title5 = TextAttributes()
        .font(Self.defaultFont(size: 13, weight: .medium))
        .foregroundColor(Colors.labelPrimary)

    static let navigationTitle = TextAttributes()
        .font(Self.defaultFont(size: 17, weight: .semibold))
        .foregroundColor(Colors.labelPrimary)

    static let primaryButton = TextAttributes()
        .font(Self.defaultFont(size: 16, weight: .medium))
        .foregroundColor(Colors.labelPrimary)

    static let secondaryButton = TextAttributes()
        .font(Self.defaultFont(size: 14, weight: .medium))
        .foregroundColor(Colors.labelPrimary)

    static let navigationButton = TextAttributes()
        .font(Self.defaultFont(size: 16, weight: .medium))
        .foregroundColor(Colors.labelPrimary)

    // swiftlint:disable force_unwrapping
    static func defaultFont(size: CGFloat, weight: FontWeight, style: FontStyle = .normal) -> UIFont {
        switch (weight, style) {
        case (.bold, .normal):
            return UIFont(name: "Inter-Bold", size: size)!

        case (.bold, .italic):
            return UIFont(name: "Inter-BoldItalic", size: size)!

        case (.regular, .normal):
            return UIFont(name: "Inter-Regular", size: size)!

        case (.regular, .italic):
            return UIFont(name: "Inter-Italic", size: size)!

        case (.medium, .normal):
            return UIFont(name: "Inter-Medium", size: size)!

        case (.medium, .italic):
            return UIFont(name: "Inter-MediumItalic", size: size)!

        case (.semibold, .normal):
            return UIFont(name: "Inter-SemiBold", size: size)!

        case (.semibold, .italic):
            return UIFont(name: "Inter-SemiBoldItalic", size: size)!

        case (.extrabold, .normal):
            return UIFont(name: "Inter-ExtraBold", size: size)!

        case (.extrabold, .italic):
            return UIFont(name: "Inter-ExtraBoldItalic", size: size)!
        }
    }
}

enum FontWeight {
    case regular
    case medium
    case semibold
    case bold
    case extrabold
}

enum FontStyle {
    case normal
    case italic
}

private struct TextAttributesModifier: ViewModifier {
    let attributes: TextAttributes

    func body(content: Content) -> some View {
        return content
            .font(.init(attributes.font ?? .systemFont(ofSize: 13)))
            .foregroundColor(Color(attributes.foregroundColor ?? .black))
            .lineSpacing(attributes.lineSpacing)
    }
}

extension View {
    func textAttributes(_ attributes: TextAttributes) -> some View {
        return modifier(TextAttributesModifier(attributes: attributes))
    }
}
