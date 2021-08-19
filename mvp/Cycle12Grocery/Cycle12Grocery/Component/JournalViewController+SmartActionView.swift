//
//  SmartAction.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/13/21.
//

import Foundation
import UIKit
import Combine

protocol SmartActionViewDelegate: NSObject {
    func smartActionView(didPerform action: SmartAction)
}

enum SmartAction {
    case logValue
    case checkinOne
    case complete
    case timer
}

class SmartActionView: UIView {
    var isAutomated: Bool = false {
        didSet {
            isAutomatedSubject.send(isAutomated)
        }
    }
    
    var goalUnitCategory: UnitCategory? {
        didSet {
            goalUnitCategorySubject.send(goalUnitCategory)
        }
    }
    
    var goalValue: Double = 0 {
        didSet {
            goalValueSubject.send(goalValue)
        }
    }
    
    weak var delegate: SmartActionViewDelegate?
    
    private var goalUnitCategorySubject = PassthroughSubject<UnitCategory?, Never>()
    private var goalValueSubject = PassthroughSubject<Double, Never>.init()
    private var isAutomatedSubject = PassthroughSubject<Bool, Never>.init()
    
    private var action = CurrentValueSubject<SmartAction?, Never>(nil)
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    // MARK: - UI Properties
    private lazy var autoHabitView: UIImageView = {
        let image = UIImage(named: ImageAsset.smartActionAutomation.rawValue)
        let v = UIImageView(image: image)

        v.setContentHuggingPriority(.required, for: .horizontal)
        v.setContentCompressionResistancePriority(.required, for: .horizontal)

        return v
    }()
    
    private lazy var smartActionButton: UIButton = {
        let v = UIButton()
        v.setTitle("Timer", for: .normal)
        
        let color = textColor
        v.setTitleColor(color, for: .normal)
        v.titleEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 0)
        
        let image = PlatformImage(named: ImageAsset.smartActionTimer.rawValue)
        v.setImage(image, for: .normal)
        v.imageView?.tintColor = color
        
        v.layer.cornerRadius = 20
        v.contentEdgeInsets = .init(top: 8, left: 14, bottom: 8, right: 14)
        v.backgroundColor = Colors.JournalColor.smartActionBackground
        
        v.titleLabel?.adjustsFontSizeToFitWidth = true;
        
        v.setContentHuggingPriority(.required, for: .horizontal)
        v.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        v.addTarget(self, action: #selector(handleTap), for: .touchUpInside)

        return v
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        
        setupObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    private func setupObserver() {
        let isAutomated = isAutomatedSubject
        let value = goalValueSubject
        let category = goalUnitCategorySubject
            .compactMap { $0 }
        
        isAutomated
            .sink { [weak self] isAutomated in
                self?.smartActionButton.isHidden = isAutomated
                self?.autoHabitView.isHidden = !isAutomated
            }
            .store(in: &cancellableSet)
        
        // action
        Publishers.CombineLatest3(
            category,
            value,
            isAutomated
        )
        .map { (category, value, isAutomated) -> SmartAction? in
            if isAutomated {
                return nil
            }
            switch (category) {
            case .duration:
                return .timer
            case .scalar:
                if value > 1 {
                    return .checkinOne
                } else if value == 1 {
                    return .complete
                } else {
                    return nil
                }
            default:
                return .logValue
            }
        }
        .subscribe(action)
        .store(in: &cancellableSet)
        
        // update ui based on action
        action
            .sink { [weak self] action in
                self?.updateUI(basedOn: action)
            }
            .store(in: &cancellableSet)
    }
    
    private func setupView() {
        addSubview(autoHabitView)
        addSubview(smartActionButton)
        smartActionButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        autoHabitView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    private func updateUI(basedOn action: SmartAction?) {
        if let action = action {
            var title = ""
            var image: UIImage?
            switch action {
            case .complete:
                title = "Done"
                image = PlatformImage(named: ImageAsset.smartActionCompleted.rawValue)
            case .checkinOne:
                title = "+1"
                image = PlatformImage(named: ImageAsset.smartActionCompleted.rawValue)
            case .logValue:
                title = "Log"
                image = PlatformImage(named: ImageAsset.smartActionLogValue.rawValue)
            case .timer:
                title = "Timer"
                image = PlatformImage(named: ImageAsset.smartActionTimer.rawValue)
            }
            
            smartActionButton.setTitle(title, for: .normal)
            smartActionButton.setImage(image, for: .normal)
        }
    }

    @objc
    private func handleTap() {
        guard let action = self.action.value else {
            return
        }
        delegate?.smartActionView(didPerform: action)
    }
    
    private var textColor: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .unspecified, .light:
                return Colors.accentPrimary

            case .dark:
                return .white
            @unknown default:
                return Colors.accentPrimary
            }
        }
    }
}
