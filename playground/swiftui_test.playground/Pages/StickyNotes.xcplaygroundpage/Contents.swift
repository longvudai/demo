import SwiftUI
import PlaygroundSupport
import Combine

PlaygroundPage.current.needsIndefiniteExecution = true

var cancellableSet = Set<AnyCancellable>()

class ViewModel: ObservableObject {
    init() {
    }
}

let lineColor = Color(hex: "#d98285")

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var maxHeight: CGFloat = 0
    @State private var numberOfLines: Int = 0
    private let lineSpacing: CGFloat = 24
    private let vPadding: CGFloat = 6

    var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .fill(Color(hex: "#e09a90"))
                    .shadow(color: .gray.opacity(0.8), radius: 8, x: 4, y: 4)
                
                ZStack {
                    VStack(spacing: lineSpacing) {
                        ForEach(0..<numberOfLines, id: \.self) { _ in
                            Rectangle()
                                .fill(lineColor)
                                .frame(height: 2)
                        }
                    }
                    .padding(.top, lineSpacing)
                    
                    VStack {
                        Text("In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available. ")
                            .lineSpacing(6)
                        Spacer()
                    }
                    .padding(.top, 6)
                    
                }
                .padding(.horizontal, 16)
                .padding(.vertical, vPadding)
            }
            .overlay(GeometryReader { proxy -> Color in
                DispatchQueue.main.async {
                    maxHeight = proxy.size.height
                    numberOfLines = Int(floor((maxHeight - vPadding * 2 - 30) / lineSpacing))
                    print("numberOfLines", numberOfLines)
                }
                return Color.clear
            })
            .padding(20)
            
            
            ZStack(alignment: .topLeading) {
                
                tapeView
                    .rotationEffect(.degrees(-45))
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding(.top, 30)
        }
    }
    
    private var tapeView: some View {
        Rectangle()
            .fill(Color.orange)
            .opacity(0.3)
            .frame(width: 100, height: 35)
    }
}

PlaygroundPage.current.setLiveView(
    ContentView(viewModel: ViewModel())
        .frame(width: 300, height: 400)
)
