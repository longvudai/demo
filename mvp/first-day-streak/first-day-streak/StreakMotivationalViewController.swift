//
//  DayStreakViewController.swift
//  first-day-streak
//
//  Created by long vu unstatic on 7/7/21.
//

import UIKit

class StreakMotivationalViewController: UIViewController {
    // MARK: - UI Properties
    private lazy var congratulationView: CongratulationView = {
        let v = CongratulationView()
        v.delegate = self
        return v
    }()
    
    private lazy var motivationLetterView: MotivationLetterView = {
        let v = MotivationLetterView()
        v.delegate = self
        return v
    }()
    
    private var viewModel: StreakMotivationalViewModel
    
    init(viewModel: StreakMotivationalViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        setupConstraint()
        
        if let streakMotivationalContent = viewModel.getStreakMotivationalContent() {
            congratulationView.viewData = CongratulationView.ViewData(
                title: streakMotivationalContent.title,
                subTitle: streakMotivationalContent.subtitle,
                habitName: viewModel.habitName,
                currentStreakDay: viewModel.numberOfDayStreak,
                numberOfStreakDay: viewModel.maxNumberOfDayStreak,
                primaryAction: streakMotivationalContent.primaryAction,
                listWeekDay: viewModel.listDayStreak
            )
            
            motivationLetterView.viewData = MotivationLetterView.ViewData(
                userName: viewModel.userName,
                motivationLetter: streakMotivationalContent.motivationalLetter
            )
        }
        
        let optimizedSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.preferredContentSize = optimizedSize
    }
    
    // MARK: - helper
    private func setupView() {
        view.backgroundColor = Colors.background
        view.layer.cornerRadius = 15
        
        view.addSubview(congratulationView)
        view.addSubview(motivationLetterView)
        motivationLetterView.isHidden = true
    }
    private func setupConstraint() {
        congratulationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        motivationLetterView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension StreakMotivationalViewController: CongratulationViewDelegate {
    func congratulationViewDidClose(view: CongratulationView) {
        dismiss(animated: true, completion: nil)
    }
    
    func congratulationViewDidHandleAction(
        view: CongratulationView,
        actionType: StreakMotivationalContent.PrimaryAction.ActionType
    ) {
        switch actionType {
        case .share:
            // TODO: handle share action
            print("share")
        case .dismiss:
            dismiss(animated: true, completion: nil)
        case .readMotivationalLetter:
            showMotivationLetter()
        }
    }
    
    private func showMotivationLetter() {
        motivationLetterView.viewData = MotivationLetterView.ViewData.mockedValue()
        motivationLetterView.isHidden = false
        UIView.transition(
            from: congratulationView,
            to: motivationLetterView,
            duration: 0.5,
            options: .transitionFlipFromLeft) { [weak self] _ in
            self?.congratulationView.isHidden = true
        }
    }
}

extension StreakMotivationalViewController: MotivationLetterViewDelegate {
    func motivationLetterViewDidClose(view: MotivationLetterView) {
        dismiss(animated: true, completion: nil)
    }
}

extension StreakMotivationalViewController: PresentationBehavior {
    func presentationContentSizeStyle() -> PresentationContentSizeStyle {
        return .autoLayout
    }
}
