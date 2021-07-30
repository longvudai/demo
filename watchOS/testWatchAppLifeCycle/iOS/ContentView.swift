//
//  ContentView.swift
//  testWatchAppLifeCycle
//
//  Created by long vu unstatic on 7/28/21.
//

import SwiftUI
import UserNotifications

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            
            Button(action: {
                viewModel.scheduleTestNotification()
            }, label: {
                Text("Schedule Notification")
            })
            .padding()
            .background(Color.green)
            
            Button(action: {
                viewModel.requestNotificationPermission()
            }, label: {
                Text("Request Notification")
            })
            .padding()
            .background(Color.green)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var mainViewModel = MainViewModel()
    static var previews: some View {
        MainView(viewModel: mainViewModel)
            .previewDevice("iPhone 8")
    }
}
