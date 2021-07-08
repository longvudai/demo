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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraint()
        
        congratulationView.viewData = CongratulationView.ViewData(
            title: "Your First Streak",
            subTitle: "That’s great start! Let’s keep it up to gain your first 3 day streak",
            habitName: "Read Book Hehe",
            currentStreakDay: 1,
            numberOfStreakDay: 2,
            actionType: .readMotivationalLetter,
            actionTitle: "Read Our Letter",
            firstDayStreak: .sunday
        )
    }
    
    private func setupView() {
        view.backgroundColor = Colors.background
        view.layer.cornerRadius = 15
        
        view.addSubview(congratulationView)
    }
    private func setupConstraint() {
        congratulationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension DayStreakViewController: CongratulationViewDelegate {
    func congratulationViewDidClose(view: CongratulationView) {
        dismiss(animated: true, completion: nil)
    }
}
