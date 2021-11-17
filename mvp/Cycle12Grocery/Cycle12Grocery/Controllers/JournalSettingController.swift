//
//  JournalSettingController.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/27/21.
//

import Foundation
import UIKit
import SwiftUI
import SwiftUIX

struct FakeView: View {
    @State var height: CGFloat = 200
    var body: some View {
        VStack {
            Button {
                if height == 200 {
                    height = 100
                } else {
                    height = 200
                }
            } label: {
                Text("\(height)")
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
                    .background(.green)
            }
        }
    }
}

class JournalSettingController: UIViewController {
    private lazy var contentView: UIHostingView<FakeView> = {
        let viewModel = JournalSettingViewModel()
        let v = JournalSettingView(viewModel: viewModel)
        let contentView = UIHostingView<FakeView>(rootView: FakeView())
        contentView.backgroundColor = .blue
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
