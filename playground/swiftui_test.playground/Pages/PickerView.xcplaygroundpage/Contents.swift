import Combine
import Foundation
import PlaygroundSupport
import SwiftUI

PlaygroundPage.current.needsIndefiniteExecution = true

class MyViewModel: ObservableObject {
    @Published var startDate = Date()
    @Published var endDate = Date().addingTimeInterval(86_400)
}

struct ContentView: View {
    @State var day = 0
    @State var hourSelection = 0
    @State var minuteSelection = 0

    var days = [Int](0 ..< 30)
    var hours = [Int](0 ..< 24)
    var minutes = [Int](0 ..< 60)

    var body: some View {
        GeometryReader { geometry in
            HStack {
                Picker(selection: self.$day, label: Text("")) {
                    ForEach(0 ..< self.days.count) { index in
                        Text("\(self.days[index]) d").tag(index)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: geometry.size.width / 3, height: 100, alignment: .center)

                Picker(selection: self.$hourSelection, label: Text("")) {
                    ForEach(0 ..< self.hours.count) { index in
                        Text("\(self.hours[index]) h").tag(index)
                    }
                }
                .frame(width: geometry.size.width / 3, height: 100, alignment: .center)

                Picker(selection: self.$minuteSelection, label: Text("")) {
                    ForEach(0 ..< self.minutes.count) { index in
                        Text("\(self.minutes[index]) m").tag(index)
                    }
                }
                .frame(width: geometry.size.width / 3, height: 100, alignment: .center)
            }
        }
    }
}

PlaygroundPage.current.setLiveView(
    VStack {
        ContentView()
    }
    .frame(width: 475, height: 500, alignment: .top)
)
