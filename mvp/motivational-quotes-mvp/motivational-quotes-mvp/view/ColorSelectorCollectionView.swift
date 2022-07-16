//
//  ColorSelectorCollectionView.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/28/21.
//

import Foundation
import UIKit
import SnapKit

class ColorSelectorCollectionView: UICollectionView {
    
}

extension ColorSelectorCollectionView {
    enum Section {
        case all
    }
    
    struct Item: Hashable {
        let colorSet: QuoteColor
        var color: UIColor {
            return colorSet.value
        }
        var bgColor: UIColor {
            return colorSet.bgColor
        }
    }
}

extension ColorSelectorCollectionView {
    class Cell: UICollectionViewCell {
        var color: UIColor = QuoteColor.orange.value {
            didSet {
                inner.backgroundColor = color
                outer.backgroundColor = .clear
                outer.layer.borderColor = color.cgColor
            }
        }
        
        private lazy var tickView: UIImageView = {
            let v = UIImageView()
            if let tick = UIImage(named: "tick") {
                v.image = tick
            }
            v.tintColor = .white
            return v
        }()
        
        private lazy var inner: UIView = {
            let v = UIView()
            v.backgroundColor = color
            v.layer.cornerRadius = 12
            v.translatesAutoresizingMaskIntoConstraints = false
            
            return v
        }()
        
        private lazy var outer: UIView = {
            let v = UIView()
            v.layer.borderWidth = 2
            v.layer.cornerRadius = 16
            
            v.translatesAutoresizingMaskIntoConstraints = false
            
            return v
        }()
        
        override var isSelected: Bool {
            didSet {
                outer.isHidden = !isSelected
                tickView.isHidden = !isSelected
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setupView()
            setupConstraint()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupView() {
            let views = [outer, inner, tickView]
            views.forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
            
            outer.isHidden = true
            tickView.isHidden = true
        }
        
        private func setupConstraint() {
            outer.snp.makeConstraints { $0.edges.equalToSuperview() }
            inner.snp.makeConstraints { $0.edges.equalToSuperview().inset(4) }
            tickView.snp.makeConstraints { $0.centerX.centerY.equalToSuperview() }
        }
    }
}

extension UICollectionViewCell {
    static var _reuseIdentifier: String {
        return String(describing: self)
    }
}
