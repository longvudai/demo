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
    
    private lazy var testView1: UIView = {
        let v = UIView()
        v.tag = 1
        v.backgroundColor = .brown
        return v
    }()
    
    private lazy var testView2: UIView = {
        let v = UIView()
        v.tag = 2
        v.backgroundColor = .systemPink
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(testButton)
        testButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        
        view.addSubview(testView1)
        testView1.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        view.addSubview(testView2)
        testView2.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(100)
            $0.top.equalToSuperview()
//            $0.top.equalTo(testView1.snp.bottom)
        }
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        testView1.addGestureRecognizer(tap1)
//        testView2.addGestureRecognizer(tap2)
    }
    
    @objc
    private func showDayStreakViewController() {
        let viewModel = StreakMotivationalViewModel(userName: "Long Vu", habitName: "Read Book", numberOfDayStreak: 1, listDayStreak: WeekDay.allCases)
        let dayStreakViewController = StreakMotivationalViewController(viewModel: viewModel)
        presentAsBottomCard(for: dayStreakViewController, animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("tap", sender?.view?.tag)
    }
}

