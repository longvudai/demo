//
//  TextController.swift
//  first-day-streak
//
//  Created by longvu on 8/4/21.
//

import Foundation
import UIKit
import SnapKit

class TextController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.text = "Ai còn nghe lại điểm danh! Vẫn hay như ngày nào."
        return v
    }()
    
    private var inputTextField: UITextField = {
        let v = UITextField()
        v.placeholder = "enter some text..."
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(inputTextField)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        inputTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
}

extension TextController: PresentationBehavior {
    var bottomCardPresentationContentSizing: BottomCardPresentationContentSizing {
        return .autoLayout
    }
}
