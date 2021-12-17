import SwiftUI
import UIKit

public struct SlideButton: View {
    public struct Configuration {
        let threshold: CGFloat
        let padding: CGFloat
        let thumbSize: CGSize
        let color: SlideButtonColor
        let thumbColor: Color

        public init(
            threshold: CGFloat = 0.8,
            padding: CGFloat = 6,
            thumbSize: CGSize = CGSize(width: 41, height: 41),
            color: SlideButtonColor,
            thumbColor: Color = .white
        ) {
            self.threshold = threshold
            self.padding = padding
            self.thumbSize = thumbSize
            self.color = color
            self.thumbColor = thumbColor
        }
    }

    public enum SlideButtonColor {
        case gradient(leftColor: Color, rightColor: Color)
        case solid(Color)
    }

    private enum DraggableState {
        case ready
        case dragging(offsetX: CGFloat, maxX: CGFloat)
        case end(offsetX: CGFloat)

        var reachEnd: Bool {
            switch self {
            case .ready, .dragging:
                return false
            case .end:
                return true
            }
        }

        var isReady: Bool {
            switch self {
            case .dragging, .end:
                return false
            case .ready:
                return true
            }
        }

        var offsetX: CGFloat {
            switch self {
            case .ready:
                return 0

            case let .dragging(offsetX, _):
                return offsetX

            case let .end(offsetX):
                return offsetX
            }
        }

        var textColorOpacity: Double {
            switch self {
            case .ready:
                return 1.0

            case let .dragging(offsetX, maxX):
                return 1.0 - Double(offsetX / maxX)

            case .end:
                return 0.0
            }
        }
    }

    let title: String
    let configuration: Configuration
    let action: () -> Void

    public init(title: String, configuration: Configuration, action: @escaping () -> Void) {
        self.title = title
        self.configuration = configuration
        self.action = action
    }

    var resetAnimation: Animation = .easeIn(duration: 0.3)

    @State private var offsetX: CGFloat = 0
    @State private var draggableState: DraggableState = .ready

    public var body: some View {
        contentView
    }

    @ViewBuilder
    private var contentView: some View {
        GeometryReader { proxy in
            setupView(width: proxy.size.width)
        }
    }

    private var thumbView: some View {
        Circle()
            .fill(configuration.thumbColor)
            .frame(
                width: configuration.thumbSize.width,
                height: configuration.thumbSize.height
            )
    }

    @ViewBuilder
    private var backgroundColor: some View {
        switch configuration.color {
        case let .solid(color):
            color
        case let .gradient(leftColor, rightColor):
            LinearGradient(
                gradient: Gradient(colors: [leftColor, rightColor]),
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }

    // MARK: - Helper

    private var textColor: Color {
        let color = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .black

            case .light:
                return .white

            case .unspecified:
                return .white
            }
        }

        let opacity: CGFloat = {
            switch draggableState {
            case .ready:
                return 1
            case let .dragging(offsetX, maxX):
                return min(1, 1 - offsetX / maxX)
            case .end:
                return 0
            }
        }()

        return Color(color).opacity(opacity)
    }

    private func setupView(width: CGFloat) -> some View {
        func handleDragChanged(_ dragValue: DragGesture.Value) {
            offsetX = min(max(dragValue.translation.width, minValue), maxValue)
            draggableState = .dragging(offsetX: offsetX, maxX: maxValue)
        }

        func handleDragEnd(_ dragValue: DragGesture.Value) {
            let expectedOffset = min(max(dragValue.translation.width, minValue), maxValue)
            if expectedOffset < configuration.threshold * maxValue {
                offsetX = 0
                draggableState = .ready
            } else {
                offsetX = maxValue
                draggableState = .end(offsetX: offsetX)

                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    offsetX = 0
                    draggableState = .ready
                    action()
                }
            }
        }

        let minValue: CGFloat = 0
        let maxValue: CGFloat = width - configuration.thumbSize.width - 2 * configuration.padding

        return ZStack(alignment: .leading) {
            HStack {
                Text(title).foregroundColor(textColor)
                    .frame(maxWidth: .infinity)
            }

            thumbView
                .offset(x: offsetX)
                .animation(draggableState.isReady ? resetAnimation : nil)
                .gesture(
                    DragGesture()
                        .onChanged(handleDragChanged(_:))
                        .onEnded(handleDragEnd(_:))
                )
        }
        .padding(configuration.padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .cornerRadius(30)
    }
}
