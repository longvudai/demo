import SwiftUI
import PlaygroundSupport
import Combine

PlaygroundPage.current.needsIndefiniteExecution = true

var cancellableSet = Set<AnyCancellable>()

class ViewModel: ObservableObject {
    init() {
    }
}



struct ContentView: View {
    @State private var maxHeight: CGFloat = 0
    @State private var numberOfLines: Int = 0
    private let lineColor = Color(red: 0.85, green: 0.51, blue: 0.52)
    private var textHeight: CGFloat {
        font.lineHeight + lineSpacing
    }
    private let lineSpacing: CGFloat = 3
    private let lineHeight: CGFloat = 2
    
    private let font: UIFont = UIFont.systemFont(ofSize: 17)

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(hex: "#e09a90"))
                .shadow(color: .gray.opacity(0.8), radius: 8, x: 4, y: 4)
            
            ZStack {
                VStack(spacing: textHeight - lineHeight) {
                    ForEach(0..<numberOfLines, id: \.self) { _ in
                        Rectangle()
                            .fill(lineColor)
                            .frame(height: lineHeight)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, textHeight)
                
                VStack {
                    Text("In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available. "
                    )
                    .font(Font(font as CTFont))
                    .lineSpacing(lineSpacing)
                    
                    Spacer()
                }
                .padding(.top, lineSpacing)
                
            }
            .padding(16)
            
        }
        .overlay(GeometryReader { proxy -> Color in
            DispatchQueue.main.async {
                maxHeight = proxy.size.height
                numberOfLines = Int(floor(maxHeight / textHeight)) - 1
                print("numberOfLines", numberOfLines)
                print("lineSpacing", lineSpacing)
            }
            return Color.clear
        })
    }
    
    private var tapeView: some View {
        Rectangle()
            .fill(Color.orange)
            .opacity(0.3)
            .frame(width: 100, height: 35)
    }
}

PlaygroundPage.current.setLiveView(
    ContentView()
        .padding(30)
        .frame(width: 300, height: 400)
)
