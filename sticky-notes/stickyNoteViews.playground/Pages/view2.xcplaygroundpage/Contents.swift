import SwiftUI
import PlaygroundSupport
import Combine

PlaygroundPage.current.needsIndefiniteExecution = true

struct ContentView: View {
    var backgroundType: StickyNoteBackgroundType
    var tapeStyle: TapeStyle
    var angle: Angle
    
    var body: some View {
        StickyNoteView(backgroundType: backgroundType, tapeStyle: tapeStyle, angle: angle)
    }
}

struct StickyNoteView: View {
    var backgroundType: StickyNoteBackgroundType
    var tapeStyle: TapeStyle
    var angle: Angle
    
    private var backgroundColor: Color = Color(red: 0.95, green: 1.00, blue: 1.00)
    private let strokeColor = Color(red: 0.91, green: 0.96, blue: 0.99)
    private let tapeColor = Color.green.opacity(0.2)
    private let lineWidth: CGFloat = 4
    private let rectMinWidth: CGFloat = 29
    var font: UIFont = UIFont.systemFont(ofSize: 17)
    var lineSpacing: CGFloat = 3
    
    init(backgroundType: StickyNoteBackgroundType, tapeStyle: TapeStyle, angle: Angle = .degrees(0)) {
        self.backgroundType = backgroundType
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
            return EdgeInsets(top: tapeHeight / 2 + 12, leading: 12, bottom: 12, trailing: 12)
            
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
                
                StickyNoteBackgroundView(type: backgroundType, font: font, lineSpacing: lineSpacing)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            VStack {
                Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                )
                .font(Font(font as CTFont))
                .lineSpacing(lineSpacing)
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, textInset.top)
            .padding(.bottom, textInset.bottom)
            .padding(.horizontal, textInset.leading)
            
            TapeView(tapeStyle: tapeStyle, tapeColor: tapeColor)
        }
        .rotationEffect(angle)
        .padding(30)
    }
}

let width: CGFloat = 250
PlaygroundPage.current.setLiveView(
    Group {
        HStack {
            ContentView(backgroundType: .smoothLine, tapeStyle: .top, angle: .degrees(0))
                .frame(width: width, height: 300)
            
            ContentView(backgroundType: .caro, tapeStyle: .top, angle: .degrees(0))
                .frame(width: width, height: 300)
        }
        
        HStack {
            ContentView(backgroundType: .smoothLine, tapeStyle: .leftBottomRightTop, angle: .degrees(0))
                .frame(width: width, height: 300)
            
            ContentView(backgroundType: .caro, tapeStyle: .leftTopRightBottom, angle: .degrees(0))
                .frame(width: width, height: 300)
        }

//        ContentView(tapeStyle: .left, angle: .degrees(15))
//            .frame(width: 300, height: 300)
//
//        ContentView(tapeStyle: .right, angle: .degrees(-13))
//            .frame(width: 300, height: 300)
    }
        .background(Color(red: 1.00, green: 0.93, blue: 0.52))

)
