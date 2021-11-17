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

            FancyScrollView(
                headerHeight: 153,
                scrollUpHeaderBehavior: .parallax,
                scrollDownHeaderBehavior: ScrollDownHeaderBehavior.sticky
            ) {
                    Image(uiImage: UIImage(named: "example.jpeg")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                } content: {
                    VStack {
                        ForEach(0...100, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(.clear)
            }
        }
    }
}

PlaygroundPage.current.setLiveView(
    NavigationView {
        ContentView(viewModel: ViewModel())
            .navigationBarBackButtonHidden(true)
    }
        .frame(width: 300, height: 500)
)
