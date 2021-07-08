//
//  MotivationLetterView.swift
//  first-day-streak
//
//  Created by long vu unstatic on 7/8/21.
//

import UIKit
import TextAttributes

protocol MotivationLetterViewDelegate: AnyObject {
    func motivationLetterViewDidClose(view: MotivationLetterView)
}

class MotivationLetterView: UIView {
    // MARK: - UI properties
    private lazy var titleView: UILabel = {
        let v = UILabel()
        v.font = AppTextStyles.heading5.font
        v.text = "From Habitify Team ❤️"
        return v
    }()
    
    private lazy var greetingView: UILabel = {
        let v = UILabel()
        v.font = AppTextStyles.heading4.font
        return v
    }()
    
    private lazy var contentView: UITextView = {
        let v = UITextView()
        v.isEditable = false
        v.isSelectable = false
        v.font = AppTextStyles.body.font
        v.backgroundColor = .clear
        return v
    }()
    
    private lazy var stampsView: UIImageView = {
        let image = UIImage(named: "stamps")
        let v = UIImageView(image: image)
        v.setContentHuggingPriority(.required, for: .vertical)
        return v
    }()
    
    private lazy var contentContainer: UIView = {
        let v = UIView()
        v.backgroundColor = DayStreakColor.motivationLetterBackground
        v.layer.cornerRadius = 5
        return v
    }()
    
    private lazy var content: UILabel = {
        let v = UILabel()
        v.font = AppTextStyles.heading5.font
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
        v.backgroundColor = DayStreakColor.accentPrimary
        v.layer.cornerRadius = 5
        v.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        return v
    }()
    
    weak var delegate: MotivationLetterViewDelegate?
    
    var viewData: ViewData? {
        didSet {
            feedData()
        }
    }
    
    // MARK: - Initialization
    convenience init() {
        self.init(frame: .zero)
        
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        
        let contentViews = [greetingView, stampsView, contentView]
        contentViews.forEach { contentContainer.addSubview($0) }
        
        let views = [titleView, closeButton, contentContainer, actionButton]
        views.forEach { addSubview($0) }
    }
    private func setupConstraint() {
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(closeButton.snp.leading).inset(16)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        // setup content view
        contentContainer.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        greetingView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(21)
            $0.trailing.equalTo(stampsView.snp.leading).inset(21)
        }
        
        stampsView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(5)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(stampsView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.bottom.equalToSuperview().inset(17)
        }
        
        actionButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(18)
            $0.top.equalTo(contentContainer.snp.bottom).offset(15)
        }
    }
    
    @objc
    private func handleClose() {
        delegate?.motivationLetterViewDidClose(view: self)
    }
    
    @objc
    private func handleAction() {
        delegate?.motivationLetterViewDidClose(view: self)
    }
    
    private func feedData() {
        guard let data = viewData else { return }
        greetingView.text = "Dear \(data.userName),"
        
        contentView.attributedText = NSAttributedString(
            string: data.motivationLetter.content,
            attributes: AppTextStyles.body.lineSpacing(10)
        )
        
        actionButton.setTitle(data.motivationLetter.dismissButtonTitle, for: .normal)
    }
}

extension MotivationLetterView {
    struct ViewData {
        let userName: String
        let motivationLetter: MotivationLetter
    }
}

extension MotivationLetterView.ViewData {
    static func mockedValue() -> MotivationLetterView.ViewData {
        return MotivationLetterView.ViewData(userName: "Melisa", motivationLetter: MotivationLetter.mockedValue())
    }
}
