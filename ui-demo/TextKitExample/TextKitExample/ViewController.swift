//
//  ViewController.swift
//  TextKitExample
//
//  Created by Long Vu on 16/07/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let multipleTextContainerViewController = MultipleTextContainerViewController()
        multipleTextContainerViewController.willMove(toParent: self)
        addChild(multipleTextContainerViewController)
        
        multipleTextContainerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(multipleTextContainerViewController.view)
        
        NSLayoutConstraint.activate([
            multipleTextContainerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            multipleTextContainerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            multipleTextContainerViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            multipleTextContainerViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        multipleTextContainerViewController.didMove(toParent: self)
        
    }


}

