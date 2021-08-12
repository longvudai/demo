//
//  TextController.swift
//  first-day-streak
//
//  Created by longvu on 8/4/21.
//

import Combine
import Foundation
import UIKit
import SnapKit
import SwiftUI
import SwiftUIX

class TextController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.text = "Ai còn nghe lại điểm danh! Vẫn hay như ngày nào."
        v.textColor = .red
        v.backgroundColor = .lightText
        
        v.setContentHuggingPriority(.required, for: .vertical)
        v.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return v
    }()
    
    private lazy var inputTextField: UITextField = {
        let v = UITextField()
        v.placeholder = "enter some text..."
        v.delegate = self
        return v
    }()
    
    private var cancellableSet: Set<AnyCancellable> = []
    private let contentViewModel = ContentViewModel()
    
    private lazy var contentView: UIHostingView<ContentView> = {
        return UIHostingView(rootView: ContentView(viewModel: contentViewModel))
    }()
    
    private var heightConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.addSubview(titleLabel)
        
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
        }
        
//        view.addSubview(inputTextField)
//        inputTextField.snp.makeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
//            $0.leading.trailing.bottom.equalToSuperview().inset(20)
//        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
        
        contentViewModel.$isUpdated.sink { [self] _ in
            UIView.animate(withDuration: 0.3) {
                self.presentationController?.containerView?.layoutIfNeeded()
                self.presentationController?.containerView?.setNeedsLayout()
            }
        }.store(in: &cancellableSet)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
}

extension TextController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        inputTextField.snp.remakeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
//            $0.leading.trailing.bottom.equalToSuperview().inset(20)
//            $0.height.equalTo(100)
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        inputTextField.snp.remakeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
//            $0.leading.trailing.bottom.equalToSuperview().inset(20)
//        }
    }
}

extension TextController: PresentationBehavior {
    var bottomCardPresentationContentSizing: BottomCardPresentationContentSizing {
        return .autoLayout
    }
}

extension TextController {
    class ContentViewModel: ObservableObject {
        @Published var isUpdated: Bool = false
    }
    
    struct ContentView: View {
        @ObservedObject var viewModel: ContentViewModel
        @State var isView1: Bool = true
        var body: some View {
            contentView
                
        }
        
        private var contentView: some View {
            VStack {
                if isView1 {
                    view1.onDisappear(perform: {
                        viewModel.isUpdated = true
                    })
                } else {
                    view2.onDisappear(perform: {
                        viewModel.isUpdated = true
                    })
                }
            }
            
        }
        
        private var view1: some View {
            VStack {
                Text("View1")
                Button {
//                    changeView()
                    withAnimation {
                      changeView()
                    }
                } label: {
                    Text("switch to view 2")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.red)
//                .transition(.opacity)
            }
        }
        
        private var view2: some View {
            VStack {
                Text("View2")
                Button {
//                    changeView()
                    withAnimation {
                        changeView()
                    }
                } label: {
                    Text("switch to view 1")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(Color.green)
            }
            .transition(.offset(x: 0, y: 160).combined(with: .opacity))
        }
        
        private func changeView() {
            isView1.toggle()
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TextController.ContentView(viewModel: TextController.ContentViewModel())
    }
}
