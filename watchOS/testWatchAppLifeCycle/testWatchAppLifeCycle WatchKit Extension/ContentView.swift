//
//  ContentView.swift
//  testWatchAppLifeCycle WatchKit Extension
//
//  Created by long vu unstatic on 7/28/21.
//

import SwiftUI
import WatchKit

struct ContentView: View {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var extensionDelegate
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        DurationWheelView(initialValue: DateInterval(start: Date(), duration: 60)) { v in
            print(v)
        }
//        NavigationView {
//            DurationPickerView(preferredIntervals: DurationPickerView_Previews.mockedListIntervals, viewModel: DurationPickerViewModel())
//                .onChange(of: scenePhase, perform: { value in
//                print(value)
//            })
//        }
    }
    
    var containerView: some View {
        Text("Hello, World!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static let extensionDelegate = ExtensionDelegate()
    static var previews: some View {
        ContentView().previewDevice("Apple Watch Series 6 - 44mm")
    }
}
