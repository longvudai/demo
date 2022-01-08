import SwiftUI
import PlaygroundSupport
import Combine

struct ContentView: View {
    var body: some View {
        VStack {
            ColorMultiply()
        }
    }
}

struct InnerCircleView: View {
    var body: some View {
        Circle()
            .fill(Color.green)
            .frame(width: 40, height: 40, alignment: .center)
    }
}

struct InnerCircleView2: View {
    var body: some View {
        Circle()
            .strokeBorder(Color.yellow, lineWidth: 5)
            .blendMode(.multiply)
            .frame(width: 40, height: 40, alignment: .center)
    }
}


struct ColorMultiply: View {
    var body: some View {
        HStack {
            Color.red.frame(width: 100, height: 100, alignment: .center)
                .overlay(InnerCircleView(), alignment: .center)
                .overlay(Text("Normal")
                             .font(.callout),
                         alignment: .bottom)
                .border(Color.gray)

            Spacer()

            Color.red.frame(width: 100, height: 100, alignment: .center)
                .overlay(InnerCircleView2(), alignment: .center)
                .overlay(Text("Multiply")
                            .font(.callout),
                         alignment: .bottom)
                .border(Color.gray)
        }
        .padding(50)
    }
}

PlaygroundPage.current.setLiveView(
    ContentView()
        .frame(width: 300, height: 300)
)
