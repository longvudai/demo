import SwiftUI
import PlaygroundSupport
import Combine

struct ContentView: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(.green)
                .frame(width: 30, height: 50)
                .overlay(
                    largeView
                )
        }
    }
    
    private var largeView: some View {
        Rectangle()
            .fill(.red.opacity(0.3))
            .frame(width: 100, height: 10)
    }
}

PlaygroundPage.current.setLiveView(
    ContentView()
        .frame(width: 300, height: 300)
)
