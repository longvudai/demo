//
//  JournalSettingView.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/18/21.
//

import Foundation
import SwiftUI
import Combine
import UIKit


struct JournalSettingView: View {
    @ObservedObject var viewModel: JournalSettingViewModel
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            contentView
                .background(.red)
                .navigationBarTitle("Hello")
                .navigationBarColor(.red)
        }
    }
    
    private var contentView: some View {
        VStack {
            if #available(iOS 14.0, *) {
                list
                .listStyle(InsetGroupedListStyle())
            } else {
                // Fallback on earlier versions
                list
                    .listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
            }
            
            if viewModel.title.count > 3 {
                Text("additional text")
                    .frame(height: 100)
            }
        }
    }
    
    private var list: some View {
        List {
            Section(header:
                        Text("Journal Name".uppercased())
                            .foregroundColor(.labelSecondary)
                            .textAttributes(AppTextStyles.caption2)
                            .frame(height: 16)
                            .padding(.leading, 8)
                            .padding(.bottom, 5)
                            .padding(.top, 12)
            ) {
                ZStack {
                    TextField(
                        "",
                        text: $viewModel.title
                    ) { isEditing in
                        self.isEditing = isEditing
                    } onCommit: {
                        viewModel.commit = true
                    }
                    .foregroundColor(.labelPrimary)
                    .font(.system(size: 17))
                    .frame(height: 45)
                }
            }
            
            Section(header: Text("Layout".uppercased())
                        .foregroundColor(.labelSecondary)
                        .textAttributes(AppTextStyles.caption2)
            ) {
                layoutSelectionView
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    
    private var layoutSelectionView: some View {
        HStack(spacing: 20) {
            JournalLayoutAnnouncement.JournalLayoutView(layout: .iconlessLayout, selectedLayout: $viewModel.selectedLayout)
            JournalLayoutAnnouncement.JournalLayoutView(layout: .iconLayout, selectedLayout: $viewModel.selectedLayout)
        }
    }
}

struct JournalSettingView_Previews: PreviewProvider {
    static let viewModel = JournalSettingViewModel()
    static var previews: some View {
        Group {
            JournalSettingView(viewModel: viewModel)
            
//            JournalSettingView(viewModel: viewModel)
//                .preferredColorScheme(.dark)
        }
        .previewDevice(PreviewDevice(stringLiteral: "iPhone 11 Pro (14.5)"))
        
    }
}

class JournalSettingViewModel: ObservableObject {
    @Published var title = "My"
    @Published var commit = false
    @Published var selectedLayout: JournalLayout?
}
