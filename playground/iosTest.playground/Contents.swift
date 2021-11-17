//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        let image = UIImage(named: "test")?.withRenderingMode(.alwaysTemplate).withTintColor(.red)
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .green
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        
        view.addSubview(label)
        view.addSubview(imageView)
        self.view = view
        
        if let image = image?.colored(.cyan) {
            saveImage(image: image)
            
        }
    }
    
    func saveImage(image: UIImage) -> Bool{
        guard let data = image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        print(directory)
        
        do{
            try data.write(to: directory.appendingPathComponent("asdasd.png")!)
            print(directory)
            print(data)
            print("si se pudo")
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    } // saveImage
}

extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func colored(_ color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            self.draw(at: .zero)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: .sourceAtop)
        }
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
