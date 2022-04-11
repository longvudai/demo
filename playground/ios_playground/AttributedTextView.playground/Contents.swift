//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import SnapKit

class MyViewController : UIViewController {
    private var attributes: [NSAttributedString.Key: Any] = {
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        let v: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17),
            .paragraphStyle: paragraphStyle
        ]
        
        return v
    }()
    
    private lazy var textView: UITextView = {
        let v = UITextView()
        v.text = "Placeholder"
        v.attributedText = NSAttributedString(
            string: "Initial text",
            attributes: attributes
        )
        v.backgroundColor = .green
        return v
    }()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
