//
//  DurationWheel.swift
//  testWatchAppLifeCycle WatchKit Extension
//
//  Created by long vu unstatic on 7/28/21.
//

import Foundation

import SwiftUI

struct DurationWheelView: View {
    typealias SaveHandler = (DateInterval) -> Void
    @State private var currentDateInterval: DateInterval
    @Environment(\.presentationMode) var presentationMode
    
    private let minValue: Double = 0
    private let maxValue: Double = 5 * 3600 // 5 hour
    private let step: Double = 60
    
    private let onSave: SaveHandler
    
    init(initialValue: DateInterval, onSave: @escaping SaveHandler) {
        self._currentDateInterval = State(initialValue: initialValue)
        self.onSave = onSave
    }
    
    var body: some View {
        VStack {
            Text(DurationFormatter.string(from: currentDateInterval.duration))
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.white.opacity(0.1))
                .border(Color.accentPrimary, width: 2)
                .cornerRadius(8)

            HStack(spacing: 6) {
                Button(action: {
                    currentDateInterval.duration = max(currentDateInterval.duration - step, minValue)
                }, label: {
                    Image("LogMinus")
                })
                .frame(maxWidth: .infinity)
                .disabled(currentDateInterval.duration <= minValue)

                Button(action: {
                    currentDateInterval.duration = min(currentDateInterval.duration + step, maxValue)
                }, label: {
                    Image("LogPlus")
                })
                .frame(maxWidth: .infinity)
                .disabled(currentDateInterval.duration >= maxValue)
            }
            
            Spacer()
            
            Button(action: {
                onSave(currentDateInterval)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Save")
            })
            .buttonStyle(PrimaryButtonStyle())
        }
        .focusable(true)
        .digitalCrownRotation(
            $currentDateInterval.duration,
            from: minValue,
            through: maxValue,
            by: 60
        )
    }
}

extension DurationWheelView {
    class DurationFormatter {
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

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.accentPrimary.cornerRadius(8))
    }
}

struct QuantityPicker_Previews: PreviewProvider {
    static let initialValue = DateInterval(start: Date(), duration: 10)
    static var previews: some View {
        DurationWheelView(initialValue: initialValue) { v in
            print(v)
        }
    }
}
