//: [Previous](@previous)

import SwiftUI
import PlaygroundSupport
import Combine

var cancellableSet = Set<AnyCancellable>()

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
dateFormatter.locale = Locale(identifier: "en_US_POSIX")
dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

struct ContentView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            ZStack {
                Image(systemName: "heart.fill")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.red)
            }
            .frame(width: 16)
            .frame(maxHeight: .infinity)
            .background(Color.yellow)

            Text("data.habitName")
                .font(.system(size: 13, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 14)
        }
        .padding(.horizontal, 12)
        .frame(maxHeight: .infinity)
        .background(.green)
    }
}


PlaygroundPage.current.setLiveView(
    ContentView()
        .frame(width: 300, height: 40, alignment: Alignment(horizontal: .center, vertical: .center))
)

PlaygroundPage.current.needsIndefiniteExecution = true


//: [Next](@next)
