//
//  ColorSelectorCollectionView.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/28/21.
//

import Foundation
import SnapKit
import UIKit

class ColorSelectorCollectionView: UICollectionView {}

extension ColorSelectorCollectionView {
    class Cell: UICollectionViewCell {
        private let inset: CGFloat = 4
        var color: UIColor = .red {
            didSet {
                inner.backgroundColor = color
                outer.backgroundColor = .clear
                outer.layer.borderColor = color.cgColor
            }
        }

        private lazy var tickView: UIImageView = {
            let v = UIImageView()
            if let tick = UIImage(named: "quote-tick") {
                v.image = tick
            }
            v.tintColor = .white
            return v
        }()

        private lazy var inner: UIView = {
            let v = UIView()
            v.backgroundColor = color
            v.layer.cornerRadius = (frame.width - inset * 2) / 2
            v.translatesAutoresizingMaskIntoConstraints = false

            return v
        }()

        private lazy var outer: UIView = {
            let v = UIView()
            v.layer.borderWidth = 2
            v.layer.cornerRadius = frame.width / 2

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
            setupConstraints()
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
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

        private func setupConstraints() {
            outer.snp.makeConstraints { $0.edges.equalToSuperview() }
            inner.snp.makeConstraints { $0.edges.equalToSuperview().inset(inset) }
            tickView.snp.makeConstraints { $0.centerX.centerY.equalToSuperview() }
        }
    }
}
