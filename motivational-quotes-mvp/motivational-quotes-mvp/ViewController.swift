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
        
        v.delegate = self
        
        return v
    }()
    
    private lazy var quoteView: QuoteView = {
        let v = QuoteView(content: "Discipline is choosing between what you want now and what you want most", author: "― Abraham Lincoln")
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let views: [UIView] = [collectionView, quoteView]
        views.forEach { view.addSubview($0) }
        setupConstraint()
        
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
    
    private func setupConstraint() {
        quoteView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(0)
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func applyInitialData() {
        var snapshot = NSDiffableDataSourceSnapshot<MyCollectionView.Section, MyCollectionView.Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(MyCollectionView.fakeMainSectionItems, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let newHeight = abs(offsetY)
        if (offsetY < 0) {
            quoteView.snp.updateConstraints {
                $0.height.equalTo(newHeight)
            }
        }
    }
}
