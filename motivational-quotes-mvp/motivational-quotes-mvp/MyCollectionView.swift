//
//  MyCollectionView.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/28/21.
//

import Foundation
import UIKit

class MyCollectionView: UICollectionView {
    static var fakeMainSectionItems = (1...10).map { index -> Item in
        return Item(
            title: "Item \(index)",
            subtitle: "First section",
            image: UIImage(named: "images")!
        )
    }
}

extension MyCollectionView {
    struct Item: Hashable {
        var title: String
        var subtitle: String
        var image: UIImage
    }
    
    enum Section {
        case main
        case second
    }
}
