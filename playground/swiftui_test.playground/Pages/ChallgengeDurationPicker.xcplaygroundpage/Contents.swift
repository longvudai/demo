import Foundation
import SwiftUI
import PlaygroundSupport
import Combine

PlaygroundPage.current.needsIndefiniteExecution = true

struct ChallengeDurationPicker: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    @State private var selection: String?
    
    private let fromId = "From"
    private let toId = "To"
    
    var body: some View {
        contentView
    }
    
    private var contentView: some View {
        VStack(spacing: 0) {
            dateIntervalView
                .frame(height: 112)
            
            if let selection = selection {
                DatePicker("", selection: selection == fromId ? _startDate : _endDate)
                    .datePickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 14)
                    .fixedSize(horizontal: true, vertical: false)
                    .clipped()
                    .background(Color.red)
                    
            }
        }
        .frame(alignment: .top)
    }
    
    private var dateIntervalView: some View {
        HStack(spacing: 20) {
            DateButton(id: fromId, date: startDate, selection: $selection)
            
            VStack {
                Image(systemName: "arrow.forward")
                    .renderingMode(.template)
    //                .foregroundColor() \.labelSecondary
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 19)
            .background(.red)
            
            DateButton(id: toId, date: endDate, selection: $selection)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 20)
    }
    
    fileprivate struct DateButton: View {
        let dateFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "MMM dd, yyyy"
            return f
        }()
        
        let id: String
        var date: Date
        @Binding var selection: String?
        
        var body: some View {
            Button {
                if selection != id {
                    selection = id
                } else {
                    selection = nil
                }
            } label: {
                VStack(alignment: .leading, spacing: 8) {
                    Text(id.uppercased())
//                        .font() \.caption1
                        .foregroundColor(foregroundColor)
                    
                    HStack {
                        Text(dateFormatter.string(from: date))
        //                    .font() \.title3
                            .foregroundColor(foregroundColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(backgroundColor)
                    .cornerRadius(5)
                }
                .frame(height: 48, alignment: .leading)
            }
        }
        
        private var backgroundColor: Color {
            if selection == id {
                return Color.green // accent
            } else {
                return Color.yellow // bgL2
            }
        }
        
        private var foregroundColor: Color {
            if selection == id {
                return Color.blue // accent
            } else {
                return Color.gray // bgL2
            }
        }
    }
}

class MyViewModel: ObservableObject {
    @Published var startDate = Date()
    @Published var endDate = Date().addingTimeInterval(86400)
}
struct ContentView: View {
    @ObservedObject var viewModel = MyViewModel()
    
    var body: some View {
        ChallengeDurationPicker(
            startDate: $viewModel.startDate,
            endDate: $viewModel.endDate
        )
    }
}

PlaygroundPage.current.setLiveView(
    VStack {
        ContentView()
    }
        .frame(width: 475, height: 500, alignment: .top)
)

