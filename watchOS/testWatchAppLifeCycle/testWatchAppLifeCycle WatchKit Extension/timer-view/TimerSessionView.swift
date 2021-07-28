//
//  TimerSessionView.swift
//  watchOS Revamp Extension
//
//  Created by Peter Vu on 03/06/2021.
//  Copyright © 2021 Peter Vu. All rights reserved.
//

import Foundation
import SwiftUI

struct TimerSessionView: View {
    @ObservedObject var viewModel: TimerSessionViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                CircleProgressBar(value: 0.7,
                                  maxValue: 1,
                                  style: .line,
                                  backgroundEnabled: true,
                                  backgroundColor: .green.opacity(0.1),
                                  foregroundColor: .green,
                                  lineWidth: 10)
                
                VStack(spacing: 2) {
                    Text("Read Book")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white)
                        .opacity(0.5)
                    Text("01:59")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 12)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .center)
            
            HStack {
                stopButton
                pauseButton
            }.frame(height: 40)
        }
        .onAppear(perform: {
            print("viewModel", viewModel.dateInterval)
        })
        .ignoresSafeArea(.container, edges: .bottom)
    }
    
    private var stopButton: some View {
        ZStack {
            Rectangle()
                .fill(Color.red)
                .frame(width: 18, height: 18)
                .cornerRadius(3)
        }
        .padding(.horizontal, 15)
        .frame(maxHeight: .infinity)
        .background(Color.white.opacity(0.1))
        .cornerRadius(6, corners: [.topRight, .bottomRight])
    }
    
    private var pauseButton: some View {
        HStack(spacing: 6) {
            Image(systemName: "pause")
            Text("Pause")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
        .background(Color.white.opacity(0.1))
        .cornerRadius(6, corners: [.topLeft, .bottomLeft])
    }
}

struct TimerSessionView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSessionView(viewModel: TimerSessionViewModel(dateInterval: DateInterval(start: Date(), duration: 100)))
            .previewDevice("Apple Watch Series 6 - 44mm")
    }
}
