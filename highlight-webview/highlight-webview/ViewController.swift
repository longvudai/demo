//
//  ViewController.swift
//  highlight-webview
//
//  Created by Long Vu on 11/12/2020.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler {
    let marker: Marker = Marker()
    
    let orangeButton: UIButton = {
        let v = UIButton()
        v.tag = 0
        v.backgroundColor = MarkerColor.orange.value
        v.layer.cornerRadius = 10
        
        v.addTarget(self, action: #selector(highlight(_:)), for: .touchUpInside)
        
        return v
    }()
    
    let cyanButton: UIButton = {
        let v = UIButton()
        v.tag = 1
        v.backgroundColor = MarkerColor.cyan.value
        v.layer.cornerRadius = 10
        
        v.addTarget(self, action: #selector(highlight(_:)), for: .touchUpInside)
        
        return v
    }()
    
    let pinkButton: UIButton = {
        let v = UIButton()
        v.tag = 2
        v.backgroundColor = MarkerColor.pink.value
        v.layer.cornerRadius = 10
        
        v.addTarget(self, action: #selector(highlight(_:)), for: .touchUpInside)
        
        return v
    }()
    
    let eraseButton: UIButton = {
        let v = UIButton()
        v.setTitle("Erase", for: .normal)
        v.setTitleColor(.systemBlue, for: .normal)
        
        v.addTarget(self, action: #selector(erase), for: .touchUpInside)
        
        return v
    }()
    
    let eraseAllButton: UIButton = {
        let v = UIButton(type: .close)
        
        v.addTarget(self, action: #selector(eraseAll), for: .touchUpInside)
        
        return v
    }()
    
    lazy var toolBars: UIStackView = {
        let v = UIStackView(arrangedSubviews: [orangeButton, cyanButton, pinkButton, eraseButton, eraseAllButton])
        v.axis = .horizontal
        v.distribution = .fillEqually
        v.spacing = 20
        return v
    }()
    
    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let uc = config.userContentController
        
        uc.addUserScript(WKUserScript.injectViewPort())
        
        // Jquery
        uc.addUserScript(JQueryScript.core())
        
        // Rangy
        uc.addUserScript(RangyScript.core())
        uc.addUserScript(RangyScript.classapplier())
        uc.addUserScript(RangyScript.highlighter())
        uc.addUserScript(RangyScript.selectionsaverestore())
        uc.addUserScript(RangyScript.textrange())
        
        // Marker
        uc.addUserScript(MarkerScript.css())
        uc.addUserScript(MarkerScript.jsScript())
        
        uc.add(self.marker, name: MarkerScript.Handler.serialize.rawValue)
        uc.add(self.marker, name: MarkerScript.Handler.erase.rawValue)
        
        let v = WKWebView(frame: .zero, configuration: config)
        
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        marker.webView = webView
        
        let path = Bundle.main.path(forResource: "sample", ofType: "html")!
        let url = URL(fileURLWithPath: path)
        webView.loadFileURL(url, allowingReadAccessTo: url)
        
        let views = [webView, toolBars]
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            toolBars.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toolBars.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toolBars.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toolBars.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Selector
@objc func highlight(_ sender: UIButton) {
    switch sender.tag {
    case 0:
        marker.highlight(MarkerColor.orange)
    case 1:
        marker.highlight(MarkerColor.cyan)
    case 2:
        marker.highlight(MarkerColor.pink)
    default:
        break
    }
}
    
    @objc func erase() {
        marker.erase()
    }
    
    @objc func eraseAll() {
        marker.removeAll()
    }
    
    // MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }
}

