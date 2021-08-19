//
//  HabitIconCell.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/19/21.
//

import SnapKit
import UIKit

class HabitIconCollectionView: UICollectionView {}

extension HabitIconCollectionView {
    class Cell: UICollectionViewCell {
        private lazy var imageView: UIImageView = {
            let v = UIImageView()
            return v
        }()

        // MARK: - Properties

        var accentColor: UIColor = .white {
            didSet {
                formatCell(isSelected: false)
            }
        }

        var imageName: String? {
            didSet {
                if let name = imageName {
                    imageView.image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
                    imageView.tintColor = accentColor
                }
            }
        }

        override init(frame: CGRect) {
            super.init(frame: frame)

            contentView.layer.cornerRadius = 10
            contentView.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError()
        }

        override var isSelected: Bool {
            didSet {
                formatCell(isSelected: isSelected)
            }
        }

        private func formatCell(isSelected: Bool) {
            if isSelected {
                contentView.backgroundColor = accentColor
                imageView.tintColor = Colors.background
            } else {
                contentView.backgroundColor = Colors.background
                imageView.tintColor = accentColor
            }
        }
    }
}
