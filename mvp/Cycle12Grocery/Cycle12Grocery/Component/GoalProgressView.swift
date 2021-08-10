//
//  GoalProgressView.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/9/21.
//

import Foundation
import UIKit
import SnapKit
import KAProgressLabel

class GoalProgressView: UIView {
    var image: UIImage? {
        didSet {
            bgImage.image = image
        }
    }
    
    var progress: CGFloat = 0 {
        didSet {
            progressView.progress = progress
        }
    }
    
    private lazy var progressView: KAProgressLabel = {
        let v = KAProgressLabel()
        v.fillColor = .clear
        v.progressColor = Colors.accentPrimary
        v.trackWidth = 2
        v.progressWidth = 3
        v.progress = 0
        v.roundedCornersWidth = 2
        v.trackColor = Colors.separator
        v.isUserInteractionEnabled = false
        return v
    }()
    
    private lazy var bgImage: UIImageView = {
        let defaultImage = UIImage(named: "default-habit-icon")
        let v = UIImageView(image: defaultImage)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(bgImage)
        addSubview(progressView)
        
        bgImage.snp.makeConstraints { $0.edges.equalToSuperview() }
        progressView.snp.makeConstraints { $0.edges.equalToSuperview() }
        print(frame)
    }
}
