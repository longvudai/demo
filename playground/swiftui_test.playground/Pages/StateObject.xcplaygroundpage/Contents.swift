//: [Previous](@previous)

import Foundation
import SwiftUI
import PlaygroundSupport
import Combine

var cancellableSet = Set<AnyCancellable>()

class ViewModel: ObservableObject {
    @Published var textValue: String? = "fuck"
    @Published var numberValue: Int = 100
    @Published var dateValue = DateInterval(start: Date(), duration: 10)
    
    init() {
        Timer.publish(every: 2, on: .current, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                print(DateInterval(start: Date(), duration: 10))
            self?.dateValue = DateInterval(start: Date(), duration: 10)
        }.store(in: &cancellableSet)
    }
}

struct ContentView: View {
    @State var aValue = 1
    @State var bValue = 0
    @State var isPresented = false
    @StateObject var viewModel: ViewModel = ViewModel()
  
    var body: some View {
        contentView
        .frame(width: 200, height: 300)
    }
    
//    AView(number: $viewModel.dateValue)
    private var contentView: some View {
        VStack {
            Text("MainView")
            VStack {
                NavigationView {
                    NavigationLink(destination: Text("\($viewModel.dateValue.wrappedValue.end)"), isActive: $isPresented) {
                        Text("View1")
                    }
                    .frame(width: 100, height: 100)
                    .background(Color.red)
                }
            }
//                AView(number: $bValue).frame(width: 100, height: 100).onTapGesture {
//                    viewModel.numberValue += 1
//                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.green)
        .onTapGesture {
            viewModel.dateValue = DateInterval(start: Date(), duration: viewModel.dateValue.duration + 10)
        }
    }
}

struct AView: View {
//    @StateObject var viewModel: ViewModel = ViewModel()
    @Binding var number: DateInterval
    
    init(number: Binding<DateInterval>) {
        _number = number
        print("init view A")
    }
    
    var body: some View {
        VStack {
            if number.duration > 0 {
                Text("A View \(number.start)")
            } else {
                Text("empty")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow)
    }
}

struct BView: View {
    @Binding var number: Int
    
    init(number: Binding<Int>) {
        _number = number
        print("init view B")
    }
    
    var body: some View {
        VStack {
            Text("B View \(number)")
            Text("\(number)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow)
    }
}

extension AView {
    class ViewModel: ObservableObject {
        @Published var text = "hello"
        
        
        init() {
            print("init AViewModel")
        }
        
        deinit {
            print("deinit AViewModel")
        }
    }
}


PlaygroundPage.current.setLiveView(
    ContentView()
)

PlaygroundPage.current.needsIndefiniteExecution = true


//: [Next](@next)
