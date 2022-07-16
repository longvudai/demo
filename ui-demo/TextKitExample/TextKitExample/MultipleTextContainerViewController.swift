//
//  MultipleTextContainerViewController.swift
//  TextKitExample
//
//  Created by Long Vu on 16/07/2022.
//

import UIKit
import SnapKit

class MultipleTextContainerViewController: UIViewController {
    
    private let textStorange: NSTextStorage = NSTextStorage()
    private let layoutManager = NSLayoutManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textStorange.addLayoutManager(layoutManager)
        
        let textContainer1 = NSTextContainer(size: .init(width: 100, height: 100))
        layoutManager.addTextContainer(textContainer1)
        
        let textView1: UITextView = {
            let v = UITextView(frame: .zero, textContainer: textContainer1)
            v.isEditable = true
            v.isSelectable = true
            v.isScrollEnabled = false
            v.backgroundColor = .green
            v.text = """
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
"""
            return v
        }()
        
        view.addSubview(textView1)
        textView1.snp.makeConstraints {
            $0.leading.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(150)
            $0.height.equalTo(150)
        }
        
        
        
        let textContainer2 = NSTextContainer(size: .init(width: 100, height: 100))
        layoutManager.addTextContainer(textContainer2)
        
        let textView2: UITextView = {
            let v = UITextView(frame: .zero, textContainer: textContainer2)
            v.isSelectable = true
            v.isScrollEnabled = false
            v.backgroundColor = .systemCyan
//            v.text = """
//Lại một ngày nữa sắp trôi qua rồi
//Ngồi nơi đây nhìn mặt trời xuống núi
//Ăn năn xám hối để đời thứ tha
//Bao nhiêu tội lỗi của ngày hôm qua
//"""
            return v
        }()
        
        view.addSubview(textView2)
        textView2.snp.makeConstraints {
            $0.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(150)
            $0.height.equalTo(150)
        }

        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
