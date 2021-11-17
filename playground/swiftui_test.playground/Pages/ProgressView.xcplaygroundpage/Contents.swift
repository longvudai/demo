//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import SwiftUI
import Combine

struct ContentView: View {
    @State private var downloadAmount = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        CircleProgressBar(
            value: 0.8,
            maxValue: 1,
            backgroundColor: Color.gray,
            foregroundColor: Color.green
        )
            .padding()
    }
}

PlaygroundPage.current.setLiveView(
    ContentView()
        .frame(width: 100, height: 100, alignment: Alignment(horizontal: .center, vertical: .center))
)

PlaygroundPage.current.needsIndefiniteExecution = true
