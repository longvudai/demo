//
//  JournalHabitCollectionViewCell2.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/9/21.
//

import Foundation
import UIKit
import SwipeCellKit

class HabitCollectionViewCell2: SwipeCollectionViewCell {
    var habitTitle: String? {
        didSet {
            titleLabel.text = habitTitle
        }
    }
    
    var goalString: String? {
        didSet {
            subtitleLabel.text = goalString
        }
    }
    
    var habitIconName: String? {
        didSet {
            guard let imageName = habitIconName else {
                return
            }
            goalProgressView.image = UIImage(named: imageName)
        }
    }
    
    var goalProgress: CGFloat = 0 {
        didSet {
            goalProgressView.progress = goalProgress
        }
    }
    
    var smartActionIcon: UIImage? {
        didSet {
            smartActionButton.setImage(smartActionIcon, for: .normal)
        }
    }
    
    var smartActionTitle: String? {
        didSet {
            smartActionButton.setTitle(smartActionTitle ?? "", for: .normal)
        }
    }
    
    // MARK: UI properties
    private lazy var goalProgressView: GoalProgressView = {
        let v = GoalProgressView()
        v.isUserInteractionEnabled = false
        return v
    }()
    
    private lazy var checkinButton: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(checkinButtonTapped), for: .touchUpInside)
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.text = "Loading´"
//        v.font = UIFont.systemFont(ofSize: 17, weight: .medium).scaled()
        v.textColor = Colors.labelPrimary
        v.lineBreakMode = .byTruncatingTail
        v.numberOfLines = 2
        v.adjustsFontForContentSizeCategory = true
        
        return v
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let v = UILabel()
        v.text = "Loading"
//        v.font = UIFont.systemFont(ofSize: 13, weight: .medium).scaled()
        v.adjustsFontForContentSizeCategory = true
        v.textColor = Colors.labelSecondary
        v.lineBreakMode = .byWordWrapping
        return v
    }()
    
    private lazy var bottomSeparator: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.separator
        return v
    }()
    
    private lazy var smartActionButton: UIButton = {
        let v = UIButton()
        v.setTitle("Timer", for: .normal)
        
        let color = Colors.accentPrimary
        v.setTitleColor(color, for: .normal)
        v.titleEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 0)
        
        v.setImage(UIImage(named: "SmartActionTimer"), for: .normal)
        v.imageView?.tintColor = color
        
        v.layer.cornerRadius = 20
        v.contentEdgeInsets = .init(top: 8, left: 14, bottom: 8, right: 14)
        v.backgroundColor = Colors.JournalColor.smartActionBackground
        
        v.titleLabel?.adjustsFontSizeToFitWidth = true;
        
        v.setContentHuggingPriority(.required, for: .horizontal)
        v.setContentCompressionResistancePriority(.required, for: .horizontal)

        return v
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = Colors.background
        
        let views = [checkinButton, goalProgressView, titleLabel, subtitleLabel, bottomSeparator, smartActionButton]
        views.forEach { contentView.addSubview($0) }
        
        checkinButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
        }
        goalProgressView.snp.makeConstraints {
            $0.center.equalTo(checkinButton)
            $0.width.height.equalTo(checkinButton)
        }

        smartActionButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(35)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(76)
            $0.trailing.equalTo(smartActionButton.snp.leading).inset(-10)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(18)
        }

        bottomSeparator.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    // MARK: - helper
    @objc
    private func checkinButtonTapped() {
        print("check in")
    }
}
