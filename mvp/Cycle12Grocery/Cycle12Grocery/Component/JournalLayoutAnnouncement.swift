//
//  JournalLayoutAnnouncement.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/18/21.
//

import Foundation
import SwiftUI

struct JournalLayoutAnnouncement: View {
    @ObservedObject var viewModel: JournalLayoutAnnouncementViewModel
    
    var body: some View {
        contentView
    }
    
    private var contentView: some View {
        VStack {
            headerView
            layoutSelectionView
            
            Text("* You can change it later in Settings")
                .foregroundColor(Color.labelSecondary)
                // footnote
                .padding(EdgeInsets(top: 18, leading: 30, bottom: 15, trailing: 30))
            
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 6) {
            Text("NEW")
                // caption 2
                .font(.system(size: 11))
                .foregroundColor(.white)
                .frame(width: 57, height: 24)
                .background(
                    Rectangle().fill(Color.accentPrimary).cornerRadius(20)
                )
            
            Text("Journal Layout")
                .font(.system(size: 26))
                .foregroundColor(Color.labelPrimary)
               // heading2
            
            Text("Let’s take a moment to celebrate and be proud of yourself for staying.")
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(Color.labelSecondary)
        }
        .padding(EdgeInsets(top: 20, leading: 36, bottom: 20, trailing: 36))
    }
    
    private var layoutSelectionView: some View {
        HStack(spacing: 20) {
            JournalLayoutView(layout: .iconlessLayout, selectedLayout: $viewModel.selectedLayout)
            JournalLayoutView(layout: .iconLayout, selectedLayout: $viewModel.selectedLayout)
        }
        .padding(.horizontal, 26)
    }
}

extension JournalLayoutAnnouncement {
    struct JournalLayoutView: View {
        let layout: JournalLayout
        @Binding var selectedLayout: JournalLayout?
        
        private var isSelected: Bool {
            return selectedLayout == layout
        }
        
        var body: some View {
            Button(action: {
                selectedLayout = layout
            }, label: {
                VStack(spacing: 13) {
                    if layout == .iconLayout {
                        ImageView(ImageAsset.journalIconLayout.rawValue, isSelected: isSelected)
                        TextView("With Icon", isSelected: isSelected)
                    } else if layout == .iconlessLayout {
                        ImageView(ImageAsset.journalIconlessLayout.rawValue, isSelected: isSelected)
                        TextView("No Icon", isSelected: isSelected)
                    }
                }
            })
        }
        
        private func ImageView(_ name: String, isSelected: Bool) -> some View {
            let image = Image(name)
                .renderingMode(.original)
                .resizable()
                .scaledToFill()
            .frame(maxWidth: 136, maxHeight: 147)
            if isSelected {
                return image.overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentPrimary, lineWidth: 3)
                ).eraseToAnyView()
            } else {
                return image.eraseToAnyView()
            }
        }
        
        private func TextView(_ text: String, isSelected: Bool) -> some View {
            let textColor = isSelected ? .white : Color.labelSecondary
            let bgColor = isSelected ? Color.accentPrimary : Color.secondaryBackground
            return Text(text)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(textColor)
                    .background(
                        Rectangle().fill(bgColor).cornerRadius(20)
                    )
                    .frame(maxWidth: 120)
                .frame(height: 30)
        }
    }
}

struct JournalLayoutAnnouncement_Previews: PreviewProvider {
    static let viewModel = JournalLayoutAnnouncementViewModel()
    static var previews: some View {
        Group {
            JournalLayoutAnnouncement(viewModel: viewModel)
            
            JournalLayoutAnnouncement(viewModel: viewModel).preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 343, height: 450))
    }
}


enum JournalLayout {
    case iconlessLayout
    case iconLayout
}
