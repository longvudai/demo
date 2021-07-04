//
//  ViewController.swift
//  system-share
//
//  Created by Long Vu on 6/28/21.
//

import UIKit

class ViewController: UIViewController {

    private lazy var shareButton: UIButton = {
        let v = UIButton(frame: CGRect(x: 100, y: 100, width: 300, height: 80))
        v.setTitle("Share", for: .normal)
        v.addTarget(self, action: #selector(handleShare(_:)), for: .touchUpInside)
        return v
    }()
    
    private var activityViewController: UIActivityViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .red
        
        view.addSubview(shareButton)
    }
    
    @objc
    private func handleShare(_ sender: UIButton) {
        print(sender)
        
        presentActivityVC()
    }
    
    
    func presentActivityVC() {
        let items = ["demo text"] as [Any]
        activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        guard let vc = activityViewController else { return }
        present(vc, animated: true, completion: nil)
    }
}

