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
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        contentView
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }})
            .onDisappear(perform: viewModel.onDisappear)
    }
    
    private var contentView: some View {
        VStack {
            if viewModel.isCompleted {
                completedView
            } else {
                timerView
            }
        }
    }
    
    private var timerView: some View {
        VStack(spacing: 12) {
            ZStack {
                CircleProgressBar(value: viewModel.progress,
                                  maxValue: 1,
                                  style: .line,
                                  backgroundEnabled: true,
                                  backgroundColor: .accentPrimary.opacity(0.1),
                                  foregroundColor: .accentPrimary,
                                  lineWidth: 10)
                
                VStack(spacing: 2) {
                    Text(viewModel.habitName)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white)
                        .opacity(0.5)
                    if let padString = viewModel.countDownText {
                        Text(padString)
                            .font(.system(size: 30, weight: .medium))
                            .foregroundColor(.white)
                    }
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
    
    private var completedView: some View {
        VStack {
            Image("tick")
                .padding(.bottom, 13)
            Text("Completed")
                .font(.system(size: 19))
                .padding(.bottom, 6)
            Text("A total of 15 minutes has been added to Read Book")
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
        }
        .frame(alignment: .center)
        .padding(12)
    }
}

struct TimerSessionView_Previews: PreviewProvider {
    static let viewModel = TimerSessionViewModel.mockedValue
    static var previews: some View {
        TimerSessionView(viewModel: viewModel)
            .previewDevice("Apple Watch Series 6 - 44mm")
    }
}
