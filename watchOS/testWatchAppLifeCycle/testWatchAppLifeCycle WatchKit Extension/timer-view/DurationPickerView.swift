//
//  DurationPickerView.swift
//  testWatchAppLifeCycle WatchKit Extension
//
//  Created by long vu unstatic on 7/28/21.
//

import SwiftUI

import SwiftUI

struct DurationPickerView: View {
    var preferredIntervals: [DateInterval]
    
    @ObservedObject var viewModel: DurationPickerViewModel
    @State private var isShowDurationWheel = false
    @State private var isShowTimerSessionView = false
    
    var body: some View {
        contentView
            .onAppear(perform: {
                isShowDurationWheel = false
                isShowTimerSessionView = false
            })
            .fullScreenCover(isPresented: $isShowDurationWheel, content: {
                DurationWheelView(initialValue: DateInterval(start: Date(), duration: 60)) { dateInterval in
                    createTimerSessionViewModel(dateInterval: dateInterval)
                }
            })
            .fullScreenCover(isPresented: $isShowTimerSessionView, content: {
                if let timerSessionViewModel = viewModel.timerSessionViewModel {
                    TimerSessionView(viewModel: timerSessionViewModel)
                } else {
                    EmptyView()
                }
            })
    }
    
    private var contentView: some View {
        List {
            // title
            Text("Select Duration")
                .font(.system(size: 17))
                .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            
            DurationItem(durationString: "7 mins", description: "Recent")
            ForEach(preferredIntervals, id: \.self) { item in
                Button(action: {
                    createTimerSessionViewModel(dateInterval: item)
                }, label: {
                    DurationItem(durationString: DurationPickerFormatter.string(from: item.duration))
                })
                .frame(maxWidth: .infinity)
                .buttonStyle(PlainButtonStyle())
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                isShowDurationWheel.toggle()
            }, label: {
                Text("Other...")
                    .frame(maxWidth: .infinity)
                    .padding(12)
            })
        }
    }
    // MARK: - helper
    private func createTimerSessionViewModel(dateInterval: DateInterval) {
        viewModel.createTimerSessionViewModel(dateInterval: dateInterval)
        isShowTimerSessionView = true
    }
}

extension DurationPickerView {
    struct DurationItem: View {
        private var durationString: String
        private var description: String?
        private var action: () -> Void
        init(durationString: String, description: String? = nil, action: @escaping () -> Void = {}) {
            self.durationString = durationString
            self.description = description
            self.action = action
        }
        
        var body: some View {
            Button(action: action, label: {
                VStack(spacing: 4) {
                    Text(durationString)
                        .font(.system(size: 15))
                    if let desc = description {
                        Text(desc.uppercased())
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(12)
            })
        }
    }
    
    class DurationPickerFormatter {
        private static let shortFormatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.allowsFractionalUnits = false
            formatter.unitsStyle = .short
            return formatter
        }()

        static func string(from seconds: TimeInterval) -> String {
            return Self.shortFormatter.string(from: seconds) ?? ""
        }
    }
}

struct DurationPickerView_Previews: PreviewProvider {
    static let mockedListIntervals: [DateInterval] = [
        DateInterval(start: Date(), duration: 5 * 60),
        DateInterval(start: Date(), duration: 10 * 60),
        DateInterval(start: Date(), duration: 61 * 60)
    ]
    
    static let viewModel = DurationPickerViewModel()
    
    static var previews: some View {
        Group {
            NavigationView {
                DurationPickerView(preferredIntervals: mockedListIntervals, viewModel: viewModel)
            }
            DurationPickerView.DurationItem(durationString: "15 mins", description: "Goal left") {
                print("")
            }
            DurationPickerView.DurationItem(durationString: "7 mins") {
                print("")
            }
        }
            .previewDevice("Apple Watch Series 6 - 44mm")
    }
}
