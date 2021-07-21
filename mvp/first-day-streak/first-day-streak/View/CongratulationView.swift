//
//  CongratulationView.swift
//  first-day-streak
//
//  Created by long vu unstatic on 7/7/21.
//

import UIKit
import SnapKit
import TextAttributes

protocol CongratulationViewDelegate: AnyObject {
    func congratulationViewDidClose(view: CongratulationView)
    func congratulationViewDidHandleAction(
        view: CongratulationView,
        actionType: StreakMotivationalContent.PrimaryAction.ActionType
    )
}

private class HabitNameTextView: UITextView {
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(.zero)
    }
}

class CongratulationView: UIView {
    // MARK: - UI properties
    private lazy var imageBackgroundView: UIImageView = {
        let image = UIImage(named: "day-streak-background") ?? UIImage()
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
        v.backgroundColor = StreakMotivationalColor.accentPrimary
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
        v.lineBreakMode = .byWordWrapping
        
        v.font = AppTextStyles.body.font
        v.textColor = Colors.labelSecondary
        v.textAlignment = .center
                
        return v
    }()
    
    private lazy var habitNameView: HabitNameTextView = {
        let v = HabitNameTextView()
        v.font = AppTextStyles.title3.font
        v.textColor = Colors.labelSecondary
        v.textAlignment = .center
        v.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
        v.layer.cornerRadius = 5

        v.textContainer.maximumNumberOfLines = 1
        v.textContainer.lineBreakMode = .byTruncatingTail
        v.textContainerInset = UIEdgeInsets(top: 8, left: 29, bottom: 8, right: 29)
        v.isEditable = false
        v.isSelectable = false
        
        return v
    }()
    
    private lazy var streakStackView: UIStackView = {
        let v = UIStackView()
        v.distribution = .equalCentering
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
        let views = [imageBackgroundView, iconView, closeButton, titleView, subTitleView, habitNameView, streakStackView, actionButton]
        views.forEach { addSubview($0) }
    }
    
    private func setupConstraint() {
        imageBackgroundView.snp.makeConstraints {
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
            $0.centerX.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        streakStackView.snp.makeConstraints {
            $0.top.equalTo(habitNameView.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview().inset(16)
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
        habitNameView.text = "Read book Read book Read book Read books"//data.habitName
        actionButton.setTitle(data.primaryAction.title, for: .normal)
        
        if (data.currentStreakDay >= 0 && data.currentStreakDay <= data.numberOfStreakDay) {
            let weekDays = data.listWeekDay
            let streakDays = Array(repeating: true, count: data.currentStreakDay) + Array(repeating: false, count: max(0, data.numberOfStreakDay - data.currentStreakDay))
            let numberOfStreakDay = data.numberOfStreakDay
            
            if weekDays.count >= numberOfStreakDay {
                var spacing = 28
                switch numberOfStreakDay {
                case 4:
                    spacing = 24
                case 5:
                    spacing = 12
                case 6, 7:
                    spacing = 7
                default:
                    break
                }
                
                let views = streakDays
                    .enumerated()
                    .flatMap { (index, isActive) -> [UIView] in
                        let calendar = Calendar.current
                        let weekDay = weekDays[index]
                        let dayOfTheWeek = streakDays.count > 5 ? calendar.shortWeekDaySymbol(from: weekDay) : calendar.veryShortWeekDaySymbol(from: weekDay)
                        let streakView = createStreakView(dayOfTheWeek: dayOfTheWeek, isActive: isActive)
                        let connectLineView = ConnectLineView(isActive: index + 1 < data.currentStreakDay, size: CGSize(width: spacing, height: 2))
                        return index < (numberOfStreakDay - 1) ?  [streakView, connectLineView] : [streakView]
                    }
                views.forEach {
                    streakStackView.addArrangedSubview($0)
                }
                
                streakStackView.spacing = 0
            }
        }
    }
    
    @objc
    private func handleClose() {
        delegate?.congratulationViewDidClose(view: self)
    }
    
    @objc
    private func handleAction() {
        guard let actionType = viewData?.primaryAction.actionType else { return  }
        delegate?.congratulationViewDidHandleAction(view: self, actionType: actionType)
    }
}

extension CongratulationView {
    struct ViewData {
        let title: String
        let subTitle: String
        let habitName: String
        let currentStreakDay: Int
        let numberOfStreakDay: Int
        let primaryAction: StreakMotivationalContent.PrimaryAction
        let listWeekDay: [WeekDay]
    }
}

// MARK: - Mock CongratulationView.ViewData
extension CongratulationView.ViewData {
    static func mockedViewData2() -> CongratulationView.ViewData {
        return CongratulationView.ViewData(
            title: "2 Day in a Row!",
            subTitle: "Keep the flame lit! You’re just one step away from your fist achievement Keep the flame lit! You’re just one step away from your fist achievement Keep the flame lit! You’re just one step away from your fist achievement Keep the flame lit! You’re just one step away from your fist achievement",
            habitName: "Read Book asdhakjsdhkajhsd",
            currentStreakDay: 2,
            numberOfStreakDay: 3,
            primaryAction: StreakMotivationalContent.PrimaryAction(title: "Read Our Letter", actionType: .readMotivationalLetter),
            listWeekDay: WeekDay.allCases
        )
    }
    
    static func mockedViewData1() -> CongratulationView.ViewData {
        return CongratulationView.ViewData(
            title: "Your First Streak",
            subTitle: "That’s great start! Let’s keep it up to gain your first 3 day streak",
            habitName: "Read Book Hehe",
            currentStreakDay: 3,
            numberOfStreakDay: 7,
            primaryAction: StreakMotivationalContent.PrimaryAction(title: "Read Our Letter", actionType: .readMotivationalLetter),
            listWeekDay: [.fri, .mon, .thu, .sun, .wed, .sat, .tue]
        )
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
            labelView.textColor = isActive ? StreakMotivationalColor.streak : Colors.labelSecondary
            
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
                $0.height.equalTo(20)
            }
        }
    }
    
    class ConnectLineView: UIView {
        private lazy var dashView: UIView = {
            let v = UIView()
            return v
        }()
        
        private lazy var dashContainer: UIView = {
            let v = UIView()
            return v
        }()
        
        convenience init(isActive: Bool = true, size: CGSize) {
            self.init(frame: .init(origin: .zero, size: size))
            
            addSubview(dashContainer)
            dashContainer.snp.makeConstraints {
                $0.width.equalTo(size.width)
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().inset(30)
            }
            dashContainer.addSubview(dashView)
            dashView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            
            if (isActive) {
                drawActiveLine()
            } else {
                drawDeactiveLine()
            }
        }
        
        private func drawActiveLine() {
            drawLine(
                p0: bounds.origin,
                p1: CGPoint(x: bounds.maxX, y: bounds.origin.y),
                strokeColor: StreakMotivationalColor.streak ?? UIColor()
            )
        }
        
        private func drawDeactiveLine() {
            drawLine(
                p0: bounds.origin,
                p1: CGPoint(x: bounds.maxX, y: bounds.origin.y),
                strokeColor: UIColor(red: 0.898, green: 0.894, blue: 0.898, alpha: 1),
                lineDashPattern: [7, 3]
            )
        }
        
        private func drawLine(p0: CGPoint, p1: CGPoint, lineWidth: CGFloat = 4, strokeColor: UIColor, lineDashPattern: [NSNumber]? = nil) {
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = strokeColor.cgColor
            shapeLayer.lineWidth = lineWidth
            shapeLayer.lineDashPattern = lineDashPattern

            let path = CGMutablePath()
            path.addLines(between: [p0, p1])
            shapeLayer.path = path
            dashView.layer.addSublayer(shapeLayer)
        }
    }
}
