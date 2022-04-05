//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "More")?.withRenderingMode(.alwaysTemplate)
        let v = UIImageView(image: image)
        v.tintColor = .red
        return v
    }()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        
        imageView.frame.origin = CGPoint(x: 0, y: 0)
        
//        view.addSubview(imageView)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

extension UILabel {

    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }

}
