import SwiftUI
import PlaygroundSupport
import Combine

PlaygroundPage.current.needsIndefiniteExecution = true

enum TapeStyle {
    case left
    case top
    case right
    case leftBottomRightTop
    case leftTopRightBottom
}

struct ContentView: View {
    var tapeStyle: TapeStyle
    var angle: Angle
    
    var body: some View {
        StickyNoteView(tapeStyle: tapeStyle, angle: angle)
    }
}

struct StickyNoteView: View {
    var tapeStyle: TapeStyle
    var angle: Angle
    
    private var backgroundColor: Color = Color(red: 0.95, green: 1.00, blue: 1.00)
    private let strokeColor = Color(red: 0.91, green: 0.96, blue: 0.99)
    private let tapeColor = Color.green.opacity(0.2)
    private let lineWidth: CGFloat = 4
    private let rectMinWidth: CGFloat = 29
    
    init(tapeStyle: TapeStyle, angle: Angle = .degrees(0)) {
        self.tapeStyle = tapeStyle
        self.angle = angle
    }
    
    private var tapeHeight: CGFloat {
        switch tapeStyle {
        case .top:
            return rectMinWidth
        default:
            return 20 * 1.5
        }
    }
    
    private var topInsetNote: CGFloat {
        switch tapeStyle {
        case .top:
            return tapeHeight / 2
            
        case .left, .right, .leftTopRightBottom, .leftBottomRightTop:
            return 0
        }
    }
    
    private var textInset: EdgeInsets {
        switch tapeStyle {
        case .top:
            return EdgeInsets(top: tapeHeight, leading: 12, bottom: 12, trailing: 12)
            
        case .left, .right:
            return EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
            
        default:
            return EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: topInsetNote)
                
                noteView
            }
            
            VStack {
                textView
            }
            .padding(.top, textInset.top)
            .padding(.bottom, textInset.bottom)
            .padding(.horizontal, textInset.leading)
            
            tapeContainerView
        }
        .rotationEffect(angle)
        .padding(30)
    }
    
    private var tapeContainerView: some View {
        var tapeView: some View {
            Rectangle()
                .fill(tapeColor)
        }
        
        return GeometryReader { proxy -> ZStack in
            let tapeWidth = min(proxy.size.width / 2 - 30, 250)
            let offsetX: CGFloat = 30
            let degrees: CGFloat = 45
            
            ZStack {
                switch tapeStyle {
                case .top:
                    HStack {
                        tapeView
                            .frame(width: tapeWidth, height: tapeHeight)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                case .left:
                    HStack {
                        tapeView
                            .rotationEffect(.degrees(-degrees))
                            .offset(x: -offsetX)
                            .frame(width: tapeWidth, height: tapeHeight)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                case .right:
                    HStack {
                        tapeView
                            .rotationEffect(.degrees(degrees))
                            .offset(x: offsetX)
                            .frame(width: tapeWidth, height: tapeHeight)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                case .leftTopRightBottom:
                    VStack {
                        HStack {
                            tapeView
                                .rotationEffect(.degrees(-degrees))
                                .offset(x: -offsetX)
                                .frame(width: tapeWidth, height: tapeHeight)
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            tapeView
                                .rotationEffect(.degrees(-degrees))
                                .offset(x: offsetX)
                                .frame(width: tapeWidth, height: tapeHeight)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                case .leftBottomRightTop:
                    VStack {
                        HStack {
                            Spacer()
                            tapeView
                                .rotationEffect(.degrees(degrees))
                                .offset(x: offsetX)
                                .frame(width: tapeWidth, height: tapeHeight)
                        }
                        
                        Spacer()
                        
                        HStack {
                            tapeView
                                .rotationEffect(.degrees(degrees))
                                .offset(x: -offsetX)
                                .frame(width: tapeWidth, height: tapeHeight)
                            
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
    }
    
    private var textView: some View {
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
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

PlaygroundPage.current.setLiveView(
    Group {
        ContentView(tapeStyle: .top, angle: .degrees(0))
            .frame(width: 300, height: 300)

        ContentView(tapeStyle: .leftBottomRightTop, angle: .degrees(0))
            .frame(width: 300, height: 300)

        ContentView(tapeStyle: .leftTopRightBottom, angle: .degrees(0))
            .frame(width: 300, height: 300)

//        ContentView(tapeStyle: .left, angle: .degrees(15))
//            .frame(width: 300, height: 300)
//
//        ContentView(tapeStyle: .right, angle: .degrees(-13))
//            .frame(width: 300, height: 300)
    }
        .background(Color(red: 1.00, green: 0.93, blue: 0.52))

)
