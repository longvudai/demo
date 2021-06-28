//
//  ViewController.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/28/21.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<MyCollectionView.Section, MyCollectionView.Item>?
    
    private lazy var collectionView: MyCollectionView = {
        let listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfig)
        let v = MyCollectionView(frame: .zero, collectionViewLayout: listLayout)
        v.backgroundColor = .gray
        
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let views: [UIView] = [collectionView]
        views.forEach { view.addSubview($0) }
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MyCollectionView.Item> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            content.textProperties.color = UIColor.blue
            content.secondaryText = item.subtitle
            content.image = item.image
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        })
        
        applyInitialData()
    }
    
    private func applyInitialData() {
        var snapshot = NSDiffableDataSourceSnapshot<MyCollectionView.Section, MyCollectionView.Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(MyCollectionView.fakeMainSectionItems, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

