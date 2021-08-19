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
    
    var body: some View {
        contentView
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
        }
    }
    
    private var list: some View {
        List {
            Section(header: Text("Journal name".uppercased())) {
                TextField("", text: $viewModel.title, onCommit:  {
                    viewModel.commit = true
                })
                .onAppear(perform: {
                    UITextField.appearance().clearButtonMode = .whileEditing
                })
                .padding(.vertical, 10)
            }
            Section(header: Text("Layout".uppercased())) {
                layoutSelectionView
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
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
        JournalSettingView(viewModel: viewModel)
    }
}

class JournalSettingViewModel: ObservableObject {
    @Published var title = "My Journal"
    @Published var commit = false
    @Published var selectedLayout: JournalLayout?
}
