import CoreGraphics
import Foundation
import PlaygroundSupport
import SwiftUI
import UIKit

PlaygroundPage.current.needsIndefiniteExecution = true

public struct CheckinSlideButton: View {
    public struct Configuration {
        let threshold: CGFloat
        let padding: CGFloat
        let thumbSize: CGSize
        let color: SlideButton.SlideButtonColor
        let thumbColor: Color
        let buttonSize: CGSize
        let buttonWidth: CGFloat

        public init(
            threshold: CGFloat = 0.8,
            padding: CGFloat = 6,
            thumbSize: CGSize = CGSize(width: 41, height: 41),
            color: SlideButton.SlideButtonColor = .solid(Color.blue),
            thumbColor: Color = .white,
            buttonSize: CGSize = CGSize(width: 53, height: 53),
            buttonWidth: CGFloat
        ) {
            self.threshold = threshold
            self.padding = padding
            self.thumbSize = thumbSize
            self.color = color
            self.thumbColor = thumbColor
            self.buttonSize = buttonSize
            self.buttonWidth = buttonWidth
        }
    }

    private var buttonSize: CGSize {
        configuration.buttonSize
    }

    private var thumbColor: Color {
        configuration.thumbColor
    }

    @State private var buttonWidth: CGFloat
    @State private var isLoading = false
    @State private var isFinished = false

    private let title: String
    private let action: ((() -> Void)?, (() -> Void)?) -> Void
    private let configuration: Configuration

    public init(
        title: String,
        configuration: Configuration,
        action: @escaping ((() -> Void)?, (() -> Void)?) -> Void
    ) {
        self.title = title
        self.configuration = configuration
        self.action = action

        buttonWidth = configuration.buttonWidth
    }

    public var body: some View {
        ZStack {
            SlideButton(
                title: title,
                configuration: .init(
                    threshold: configuration.threshold,
                    padding: configuration.padding,
                    thumbSize: configuration.thumbSize,
                    color: configuration.color,
                    thumbColor: thumbColor
                ),
                action: {
                    buttonWidth = buttonSize.width
                    isLoading = true

                    action({
                        finish()
                    }, {
                        reset()
                    })
                }
            )
            .frame(width: CGFloat(buttonWidth), height: buttonSize.height, alignment: .center)
            .animation(
                .default,
                value: buttonWidth
            )

            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(thumbColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .frame(width: buttonSize.width - 6, height: buttonSize.height - 6)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(
                    Animation.linear(duration: 1).repeatForever(autoreverses: false),
                    value: isLoading
                )
                .opacity(isLoading ? 1 : 0)
                .animation(
                    Animation.default,
                    value: isLoading
                )

            Image(systemName: "checkmark")
                .resizable()
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(.systemGreen))
                .frame(width: buttonSize.width / 2, height: buttonSize.height / 2)
                .opacity(isFinished ? 1 : 0)
                .animation(.easeIn, value: isFinished)
        }
    }

    private func finish() {
        DispatchQueue.main.async {
            isLoading = false
            isFinished = true
        }
    }

    private func reset() {
        DispatchQueue.main.async {
            isLoading = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            buttonWidth = 244
        }
    }
}

PlaygroundPage.current.setLiveView(
    CheckinSlideButton(
        title: "Slide to unlock",
        configuration: CheckinSlideButton.Configuration(buttonWidth: 250)
    ) { _, onError in
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                onSuccess?()
            onError?()
        }
    }
    .preferredColorScheme(.dark)
    .frame(width: 300, height: 300)
)
