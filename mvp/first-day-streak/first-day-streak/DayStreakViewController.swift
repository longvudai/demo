//
//  DayStreakViewController.swift
//  first-day-streak
//
//  Created by long vu unstatic on 7/7/21.
//

import UIKit

class DayStreakViewController: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraint()
        
        congratulationView.viewData = CongratulationView.ViewData.mockedViewData2()
        
    }
    
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

extension DayStreakViewController: CongratulationViewDelegate {
    func congratulationViewDidClose(view: CongratulationView) {
        dismiss(animated: true, completion: nil)
    }
    
    func congratulationViewDidHandleAction(view: CongratulationView, actionType: ActionType) {
        switch actionType {
        case .share:
            print("share")
        case .dismiss:
            print("dismiss")
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

extension DayStreakViewController: MotivationLetterViewDelegate {
    func motivationLetterViewDidClose(view: MotivationLetterView) {
        dismiss(animated: true, completion: nil)
    }
}
