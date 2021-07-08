//
//  CongratulationView.swift
//  first-day-streak
//
//  Created by long vu unstatic on 7/7/21.
//

import UIKit
import SnapKit
import TextAttributes

enum ActionType {
    case share, readMotivationalLetter, dismiss
}

protocol CongratulationViewDelegate: class {
    func congratulationViewDidClose(view: CongratulationView)
}

class CongratulationView: UIView {
    // MARK: - UI properties
    private lazy var decorateView: UIImageView = {
        let image = UIImage(named: "day-streak-decorator") ?? UIImage()
        let v = UIImageView(image: image)
        return v
    }()
    
    private lazy var iconView: UIImageView = {
        let image = UIImage(named: "congrats-icon") ?? UIImage()
        let v = UIImageView(image: image)
        v.setContentHuggingPriority(.required, for: .vertical)
        return v
    }()
    
    private lazy var closeButton: UIButton = {
        let v = UIButton()
        let closeImage = UIImage(named: "day-streak-close") ?? UIImage()
        v.setImage(closeImage, for: .normal)
        v.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return v
    }()
    
    private lazy var actionButton: UIButton = {
        let v = UIButton()
        v.backgroundColor = UIColor(red: 0.165, green: 0.404, blue: 0.957, alpha: 1)
        v.layer.cornerRadius = 5
        v.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        return v
    }()
    
    private lazy var titleView: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.font = AppTextStyles.heading2.font
        v.textAlignment = .center
        return v
    }()
    
    private lazy var subTitleView: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        
        v.font = AppTextStyles.body.font
        v.textColor = Colors.labelSecondary
        v.textAlignment = .center
        
        return v
    }()
    
    private lazy var habitNameView: UITextView = {
        let v = UITextView()
        v.font = AppTextStyles.title3.font
        v.textColor = Colors.labelSecondary
        v.textAlignment = .center
        v.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
        v.layer.cornerRadius = 5
        
        v.textContainer.maximumNumberOfLines = 1
        v.textContainerInset = UIEdgeInsets(top: 8, left: 29, bottom: 8, right: 29)
        v.isEditable = false
        v.isSelectable = false
        
        return v
    }()
    
    private lazy var streakView: UIStackView = {
        let v = UIStackView()
        v.distribution = .fillEqually
        v.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return v
    }()
    
    private var habitNameLayoutConstraint: LayoutConstraint?
    
    var viewData: ViewData? {
        didSet {
            feedData()
        }
    }
    
    weak var delegate: CongratulationViewDelegate?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraint()
    }
    
    convenience init(
        viewData: ViewData
    ) {
        self.init(frame: .zero)
        self.viewData = viewData
        feedData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let views = [decorateView, iconView, closeButton, titleView, subTitleView, habitNameView, streakView, actionButton]
        views.forEach { addSubview($0) }
    }
    
    private func setupConstraint() {
        decorateView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        iconView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(23)
            $0.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.top.equalToSuperview().inset(18)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(iconView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(68)
        }
        
        subTitleView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(36)
        }
        
        habitNameView.snp.makeConstraints {
            $0.top.equalTo(subTitleView.snp.bottom).offset(22)
            habitNameLayoutConstraint = $0.width.lessThanOrEqualTo(frame.size.width).constraint.layoutConstraints.first
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        streakView.snp.makeConstraints {
            $0.top.equalTo(habitNameView.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview().inset(30)
            $0.bottom.equalTo(actionButton.snp.top).inset(-20)
        }
        
        actionButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(22)
        }
    }
    
    // MARK: - methods
    private func createStreakView(dayOfTheWeek: String, isActive: Bool = true) -> StreakView {
        let v = StreakView(dayOfTheWeek: dayOfTheWeek, isActive: isActive)
        return v
    }
    
    private func feedData() {
        guard let data = viewData else { return }
        titleView.text = data.title
        subTitleView.text = data.subTitle
        habitNameView.text = data.habitName
        actionButton.setTitle(data.actionTitle, for: .normal)
        
        // calculate habit name layout constraint
        let fixedWidth = habitNameView.frame.size.width
        let newSize = habitNameView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newWidth = max(newSize.width, fixedWidth)
        habitNameLayoutConstraint?.constant = newWidth
        
        if (data.currentStreakDay >= 0 && data.currentStreakDay <= data.numberOfStreakDay) {
            let weekDays = Weekday.allCase(from: data.firstDayStreak)
            let isActiveArray = Array(repeating: true, count: data.currentStreakDay) + Array(repeating: false, count: max(0, data.numberOfStreakDay - data.currentStreakDay))
            
            if weekDays.count >= isActiveArray.count {
                let views = isActiveArray
                    .enumerated()
                    .map { (index, isActive) -> StreakView in
                        let weekDay = weekDays[index]
                        let dayOfTheWeek = isActiveArray.count > 5 ? weekDay.dayOfTheWeek1 : weekDay.dayOfTheWeek3
                        return createStreakView(dayOfTheWeek: dayOfTheWeek, isActive: isActive)
                    }
                views.forEach { streakView.addArrangedSubview($0) }
                
                var spacing = 28
                switch views.count {
                case 4:
                    spacing = 24
                case 5:
                    spacing = 12
                case 6, 7:
                    spacing = 7
                default:
                    break
                }
                
                streakView.spacing = CGFloat(spacing)
            }
        }
    }
    
    @objc
    private func handleClose() {
        delegate?.congratulationViewDidClose(view: self)
    }
    
    @objc
    private func handleAction() {
        guard let actionType = viewData?.actionType else { return  }
        switch actionType {
        case .share:
            print("share")
        case .dismiss:
            print("dismiss")
        case .readMotivationalLetter:
            print("readMotivationalLetter")
        }
    }
}

extension CongratulationView {
    struct ViewData {
        let title: String
        let subTitle: String
        let habitName: String
        let currentStreakDay: Int
        let numberOfStreakDay: Int
        let actionType: ActionType
        let actionTitle: String
        let firstDayStreak: Weekday
    }
    
    enum Weekday: Int {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
        
        static func allCase(from weekDay: Weekday) -> [Weekday] {
             return Array(repeating: weekDay.rawValue, count: 7)
                .enumerated()
                .compactMap { (index, start) in
                    let rawValue = max((start + index) % 8, 1)
                    return Weekday(rawValue: rawValue)
                }
        }
        
        var dayOfTheWeek3: String {
            switch self {
            case .monday:
                return "Mon"
            case .tuesday:
                return "Tue"
            case .wednesday:
                return "Wed"
            case .thursday:
                return "Thu"
            case .friday:
                return "Fri"
            case .saturday:
                return "Sat"
            case .sunday:
                return "Sun"
            }
        }
        
        var dayOfTheWeek1: String {
            return String(dayOfTheWeek3[dayOfTheWeek3.startIndex])
        }
    }
}

extension CongratulationView {
    class StreakView: UIView {
        private lazy var labelView: UILabel = {
            let v = UILabel()
            v.textAlignment = .center
            v.font = AppTextStyles.title4.font
            return v
        }()
        
        private lazy var streakIcon: UIImageView = {
            let v = UIImageView()
            return v
        }()
        
        convenience init(dayOfTheWeek: String, isActive: Bool) {
            self.init(frame: .zero)
            
            let imageName = isActive ? "active-streak" : "normal-streak"
            let image = UIImage(named: imageName) ?? UIImage()
            streakIcon.image = image
            
            labelView.text = dayOfTheWeek
            labelView.textColor = isActive ? UIColor(red: 0.863, green: 0.382, blue: 0.083, alpha: 1) : Colors.labelSecondary
            
            addSubview(streakIcon)
            addSubview(labelView)

            streakIcon.snp.makeConstraints {
                $0.leading.trailing.top.equalToSuperview()
                $0.width.greaterThanOrEqualTo(32)
                $0.height.equalTo(streakIcon.snp.width)
            }
            
            labelView.snp.makeConstraints {
                $0.top.equalTo(streakIcon.snp.bottom).offset(10)
                $0.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
            }
        }
    }
}