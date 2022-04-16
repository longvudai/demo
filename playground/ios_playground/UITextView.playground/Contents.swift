//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController, UITextViewDelegate {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.textContainerInset = .zero
        textView.delegate = self
        textView.frame = CGRect(x: 50, y: 200, width: 200, height: 200)
        textView.attributedText = NSAttributedString(string: "Hello World!", attributes: [.paragraphStyle: {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            return paragraphStyle
        }()])
        textView.textColor = .black
        textView.backgroundColor = .green
        
        view.addSubview(textView)
        self.view = view
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
