import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var testButton: UIButton = {
        let v = UIButton()
        v.backgroundColor = .green
        v.setTitle("show", for: .normal)
        v.addTarget(self, action: #selector(showDayStreakViewController), for: .touchUpInside)
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(testButton)
        testButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc
    private func showDayStreakViewController() {
        let viewModel = StreakMotivationalViewModel(userName: "Long Vu", habitName: "Read Book", numberOfDayStreak: 1, listDayStreak: WeekDay.allCases)
        let dayStreakViewController = StreakMotivationalViewController(viewModel: viewModel)
        presentAsBottomCard(for: dayStreakViewController, animated: true)
    }
}

