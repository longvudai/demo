//
//  DateSelectorView.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/16/21.
//

import Foundation
import SwiftUI
import SwiftUIX
import Introspect

struct DateSelectorView: View {
    private let daySpacing: CGFloat = 10
    let dateInterval: DateInterval
    @State var selectedDate: Date? = Date()
    var body: some View {
       contentView
    }
    
    private var contentView: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(spacing: daySpacing) {
                ForEach(listDate, id: \.self) { date in
                    DayView(calendar: Calendar.current, date: date, selectedDate: $selectedDate)
                }
            }
            .padding(10)
        })
        .background(.init(hexadecimal: "#F6F6F6").opacity(0.5))
        .introspectScrollView { scrollView in
            let contentWidth = scrollView.contentSize.width
            let width = daySpacing + 47
            print(contentWidth, scrollView.frame.width)
            let x = contentWidth - scrollView.frame.width - width
            let visibleRect = CGRect(x: x, y: 0, width: scrollView.frame.width, height: 100)
            scrollView.scrollRectToVisible(visibleRect, animated: true)
        }
    }
    
    // helper
    private var listDate: [Date] {
        let calendar = Calendar.current
        let matchingDateComponents = DateComponents(hour: 0, minute: 0, second: 0)
        
        var list: [Date] = []
        
        calendar.enumerateDates(startingAfter: dateInterval.start, matching: matchingDateComponents, matchingPolicy: .nextTime) { date, strict, stop in
            if let currentDate = date {
                if currentDate > dateInterval.end {
                    stop = true
                } else {
                    list.append(currentDate)
                }
            } else {
                stop = true
            }
        }

        return list
    }
    
    struct DayView: View {
        let calendar: Calendar
        let date: Date
        @Binding var selectedDate: Date?
        
        var body: some View {
            contentView
                .frame(width: 47, height: 53, alignment: .center)
                .background(backgroundColor)
                .cornerRadius(10)
        }
        
        private var backgroundColor: Color {
            return isSelected ? Color(Colors.JournalColor.smartActionBackground) : .clear
        }
        private var textColor: Color {
            return isSelected ? Color(Colors.accentPrimary) : Color(Colors.labelSecondary)
        }
        private var isSelected: Bool {
            guard let selectedDate = selectedDate else {
                return false
            }
            return calendar.isDate(selectedDate, inSameDayAs: date)
        }
        
        private var contentView: some View {
            Button(action: {
                selectedDate = date
            }, label: {
                VStack(spacing: 5) {
                    Text(shortWeekDaySymbol(from: date).uppercased())
                        .font(.system(size: 10))
                        .foregroundColor(textColor)
                    Text("\(calendar.component(.day, from: date))")
                        .font(.system(size: 14))
                        .foregroundColor(textColor)
                }
            })
        }
        
        // helper
        private func shortWeekDaySymbol(from date: Date) -> String {
            let weekDay = calendar.weekDay(from: date) ?? .mon
            return calendar.shortWeekDaySymbol(from: weekDay)
        }
    }
}

struct DateSelectorView_Previews: PreviewProvider {
    static let tomorrow = Calendar.current.date(byAdding: .day,value: 1, to: Date())!
    static let thisDayLastMonth = Calendar.current.date(byAdding: .month, value: -1, to: tomorrow)!
    static var previews: some View {
        ZStack {
            DateSelectorView(dateInterval: DateInterval(start: thisDayLastMonth, end: tomorrow))
                .frame(width: 300, height:53)
                .previewDevice(PreviewDevice.init(stringLiteral: "iPhone 8"))
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: Alignment(horizontal: .leading, vertical: .center)
        )
        .background(.green)
    }
}
