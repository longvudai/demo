//
//  JournalHabitCollectionViewCell2.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/9/21.
//

import Foundation
import UIKit
import SwipeCellKit

class HabitCollectionViewCell2: SwipeCollectionViewCell, SmartActionViewDelegate {
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
        v.text = "Loading"
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
    
    private lazy var smartActionView: SmartActionView = {
        let v = SmartActionView()
        
        v.delegate = self
        
        v.setContentHuggingPriority(.required, for: .horizontal)
        v.setContentCompressionResistancePriority(.required, for: .horizontal)

        return v
    }()
    
    private lazy var habitStatusView: UIImageView = {
        let v = UIImageView()
        v.tintColor = Colors.labelSecondary
        v.image = UIImage(named: "JournalCheckinStatusCompleted")?.withRenderingMode(.alwaysTemplate)
        v.setContentHuggingPriority(.required, for: .horizontal)
        return v
    }()
    
    private lazy var trailingAccessoriesStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [smartActionView, habitStatusView])
        v.spacing = 12
        v.alignment = .center
        v.axis = .horizontal
        v.setContentHuggingPriority(.required, for: .horizontal)
        return v
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        smartActionView.goalValue = 1
        smartActionView.goalUnitCategory = .scalar
        smartActionView.isAutomated = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = Colors.background
        
        let views = [checkinButton, goalProgressView, titleLabel, subtitleLabel, bottomSeparator, trailingAccessoriesStackView]
        views.forEach { contentView.addSubview($0) }
        
        checkinButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
        }
        
        goalProgressView.snp.makeConstraints {
            $0.center.equalTo(checkinButton)
            $0.width.height.equalTo(checkinButton)
        }

        trailingAccessoriesStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(76)
            $0.trailing.equalTo(trailingAccessoriesStackView.snp.leading).inset(-10)
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
    
    // MARK: - Smart action view delegate
    func smartActionView(didPerform action: SmartAction) {
        print(action)
    }
}
