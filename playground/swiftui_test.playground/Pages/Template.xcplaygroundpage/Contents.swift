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
    @ObservedObject var viewModel: ViewModel
  

    var body: some View {
        VStack {
            Text("Template")
        }
    }
}

PlaygroundPage.current.setLiveView(
    ContentView(viewModel: ViewModel())
        .frame(width: 300, height: 300)
)
