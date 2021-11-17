//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController, BottomCardPresentationControllerDelegate {
    private lazy var presentButton: UIButton = {
        let v = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        v.setTitle("Present", for: .normal)
        v.backgroundColor = .red
        v.addTarget(self, action: #selector(presentView), for: .touchUpInside)
        return v
    }()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        
        view.addSubview(presentButton)
        
        self.view = view
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        
        print("dismiss in MyViewController")
    }
    
    func presentedViewControllerDidDimiss() {
        print("dismiss in MyViewController")
    }
    
    var nextViewController = NextViewController()
    
    @objc func presentView() {
        presentAsBottomCard(for: nextViewController, animated: true)
    }
}

class NextViewController: UIViewController, PresentationBehavior {
    private lazy var dismissButton: UIButton = {
        let v = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        v.setTitle("dismiss", for: .normal)
        v.backgroundColor = .green
        v.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return v
    }()
    
    var bottomCardPresentationContentSizing: BottomCardPresentationContentSizing {
        return .preferredContentSize(size: CGSize(width: 300, height: 300))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(dismissButton)
    }
    
    @objc func dismissView() {
//        presentingViewController?.dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
