import Foundation
import SwiftUI

public struct CircleProgressBar: View {
    public enum Stroke {
        case line
        case dotted

        func strokeStyle(lineWidth: CGFloat) -> StrokeStyle {
            switch self {
            case .line:
                return StrokeStyle(lineWidth: lineWidth,
                                   lineCap: .round)

            case .dotted:
                return StrokeStyle(lineWidth: lineWidth,
                                   lineCap: .round,
                                   dash: [12])
            }
        }
    }

    private let value: Double
    private let maxValue: Double
    private let style: Stroke
    private let backgroundEnabled: Bool
    private let backgroundColor: Color
    private let foregroundColor: Color
    private let lineWidth: CGFloat

    public init(value: Double,
         maxValue: Double,
         style: Stroke = .line,
         backgroundEnabled: Bool = true,
         backgroundColor: Color,
         foregroundColor: Color = Color.black,
         lineWidth: CGFloat = 10) {
        self.value = value
        self.maxValue = maxValue
        self.style = style
        self.backgroundEnabled = backgroundEnabled
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.lineWidth = lineWidth
    }

    public var body: some View {
        ZStack {
            if self.backgroundEnabled {
                Circle()
                    .stroke(lineWidth: self.lineWidth)
                    .foregroundColor(self.backgroundColor)
            }

            Circle()
                .trim(from: 0, to: CGFloat(self.value / self.maxValue))
                .stroke(style: self.style.strokeStyle(lineWidth: self.lineWidth))
                .foregroundColor(self.foregroundColor)
                .rotationEffect(Angle(degrees: -90))
                .animation(.timingCurve(0.33, 1, 0.68, 1, duration: 0.37))
        }
    }
}
