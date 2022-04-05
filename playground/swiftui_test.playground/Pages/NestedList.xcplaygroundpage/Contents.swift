import SwiftUI
import PlaygroundSupport
import Combine

PlaygroundPage.current.needsIndefiniteExecution = true

var cancellableSet = Set<AnyCancellable>()

struct Tree<Value: Hashable>: Hashable {
    let value: Value
    var children: [Tree]? = nil
}

class ViewModel: ObservableObject {
    @Published var items: [Int] = Array<Int>(0...10)
    let categories: [Tree<String>] = [
        .init(
            value: "Clothing",
            children: [
                .init(value: "Hoodies"),
                .init(value: "Jackets"),
                .init(value: "Joggers"),
                .init(value: "Jumpers"),
                .init(
                    value: "Jeans",
                    children: [
                        .init(value: "Regular"),
                        .init(value: "Slim")
                    ]
                ),
            ]
        ),
        .init(
            value: "Shoes",
            children: [
                .init(value: "Boots"),
                .init(value: "Sliders"),
                .init(value: "Sandals"),
                .init(value: "Trainers"),
            ]
        )
    ]
    init() {
    }
}

struct BookmarksDropDelegate: DropDelegate {
    @Binding var bookmarks: [URL]

    func performDrop(info: DropInfo) -> Bool {
        guard info.hasItemsConforming(to: ["public.url"]) else {
            return false
        }

        print("----info")
        let items = info.itemProviders(for: ["public.url"])
        for item in items {
            _ = item.loadObject(ofClass: URL.self) { url, _ in
                if let url = url {
                    DispatchQueue.main.async {
                        self.bookmarks.insert(url, at: 0)
                    }
                }
            }
        }

        return true
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
  

    var body: some View {
        List(viewModel.categories, id: \.self, children: \.children) { tree in
            Text(tree.value)
                .font(.subheadline)
//                .onLongPressGesture(minimumDuration: 0.1, maximumDistance: 1) {
//                    print("press")
//                } onPressingChanged: { v in
//                    print(v)
//                }
                .onLongPressGesture {
                    print("long presss")
                }

//            .onDrag {
//                print("dragging")
//                return NSItemProvider()
//            }
        }
        .navigationBarTitle(Text("Nav Title"))
        .navigationBarItems(trailing: EditButton())
    }
}

PlaygroundPage.current.setLiveView(
    NavigationView {
        ContentView(viewModel: ViewModel())
//            .frame(width: 375, height: 500)
    }
)
