import Foundation
import SwiftUI
import UIKit

public enum StickyNoteBackgroundType {
    case caro
    case smoothLine
}

public struct StickyNoteBackgroundView: View {
    private var type: StickyNoteBackgroundType
    private var font: UIFont
    private var lineSpacing: CGFloat = 6
    
    public init(type: StickyNoteBackgroundType, font: UIFont, lineSpacing: CGFloat = 6) {
        self.type = type
        self.font = font
        self.lineSpacing = lineSpacing
    }
    
    public var body: some View {
        switch type {
        case .caro:
            CaroView()
            
        case .smoothLine:
            SmoothLine(font: font, lineSpacing: lineSpacing)
        }
    }
}

private extension StickyNoteBackgroundView {
    struct SmoothLine: View {
        @State private var maxHeight: CGFloat = 0
        @State private var numberOfLines: Int = 0
        private let lineColor = Color(red: 0.85, green: 0.51, blue: 0.52)
        private let backgroundColor = Color(red: 0.88, green: 0.60, blue: 0.56)
        private var textHeight: CGFloat {
            font.lineHeight + lineSpacing
        }
        private let lineHeight: CGFloat = 2
        
        var font: UIFont = UIFont.systemFont(ofSize: 17)
        var lineSpacing: CGFloat = 3

        var body: some View {
            ZStack {
                backgroundView
                
                linesView
            }
            .overlay(GeometryReader { proxy -> Color in
                DispatchQueue.main.async {
                    maxHeight = proxy.size.height
                    numberOfLines = Int(floor(maxHeight / textHeight)) - 1
                }
                return Color.clear
            })
        }
        
        private var backgroundView: some View {
            Rectangle()
                .fill(backgroundColor)
                .shadow(color: .gray.opacity(0.8), radius: 8, x: 4, y: 4)
        }
        
        private var linesView: some View {
            ZStack {
                VStack(spacing: textHeight - lineHeight) {
                    ForEach(0..<numberOfLines, id: \.self) { _ in
                        Rectangle()
                            .fill(lineColor)
                            .frame(height: lineHeight)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, textHeight - lineSpacing)
            }
            .padding(12)
        }
    }
    
    struct CaroView: View {
        private var backgroundColor: Color = Color(red: 0.95, green: 1.00, blue: 1.00)
        private let strokeColor = Color(red: 0.91, green: 0.96, blue: 0.99)
        private let lineWidth: CGFloat = 4
        private let rectMinWidth: CGFloat = 29
        
        var body: some View {
            noteView
        }
        
        private var noteView: some View {
            ZStack {
                Rectangle()
                    .fill(backgroundColor)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 8)
            }
            .overlay(gridView)
        }
        
        private var gridView: some View {
            GeometryReader { proxy in
                Path { path in
                    let height = proxy.size.height
                    let width = proxy.size.width
                    
                    let expectedHorizontalCount = floor(width / (rectMinWidth + lineWidth))
                    let rectWidth = (width - 4 * expectedHorizontalCount - 2) / (expectedHorizontalCount + 1)
                    
                    Array<Int>(1...max(1,Int(expectedHorizontalCount) + 1)).forEach { n in
                        let x = CGFloat(n) * rectWidth
                        let start = CGPoint(x: x, y: 0)
                        let end = CGPoint(x: x, y: height)
                        path.move(to: start)
                        path.addLine(to: end)
                    }
                    
                    Array<Int>(1...Int(floor(height / rectWidth))).forEach { n in
                        let y = CGFloat(n) * rectWidth
                        if (height - rectWidth <= y) {
                            return
                        }
                        let start = CGPoint(x: 0, y: y)
                        let end = CGPoint(x: width, y: y)
                        path.move(to: start)
                        path.addLine(to: end)
                    }
                }
                .stroke(strokeColor, lineWidth: lineWidth)
            }
        }
    }
}
