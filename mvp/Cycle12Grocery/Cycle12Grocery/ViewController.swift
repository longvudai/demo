//
//  ViewController.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/9/21.
//

import UIKit
import SwipeCellKit
import SnapKit

class ViewController: UIViewController {
    var dataSource: UICollectionViewDiffableDataSource<String, Habit>?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(100)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(100)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            return NSCollectionLayoutSection(group: group)
        }
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        v.register(HabitCollectionViewCell2.self, forCellWithReuseIdentifier: "habit-cell2")
        
        v.delegate = self
        
        v.backgroundColor = .lightGray
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupView()
        
        dataSource = UICollectionViewDiffableDataSource<String, Habit>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habit-cell2", for: indexPath) as! HabitCollectionViewCell2
            cell.delegate = self


            cell.habitTitle = item.title
            cell.goalString = "\(item.currentValue) / \(item.targetValue) mins"
            cell.goalProgress = CGFloat (item.currentValue / item.targetValue)
            cell.habitIconName = item.habitIconName
            return cell
        }
        
        collectionView.dataSource = dataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<String, Habit>.init()
        snapshot.appendSections(["Section 1", "Section 2"])

        let items = [
            Habit.mockedValue1,
            Habit.mockedValue2
        ]
        snapshot.appendItems(items, toSection: "Section 1")
        dataSource?.apply(snapshot)
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ViewController: UICollectionViewDelegate, SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        switch orientation {
        case .left:
            return [checkinAction(), checkinAction()]
        case .right:
            return [checkinAction()]
        }
    }
    
    private func checkinAction() -> SwipeAction {
        let action = SwipeAction(style: .destructive, title: "Check-in", handler: nil)
        action.font =  .systemFont(ofSize: 13, weight: .medium)
        action.textColor = .white
        action.image = PlatformImage(named: "JournalSwipeCheckin")
        action.hidesWhenSelected = true
        action.backgroundColor = Colors.accentPrimary
        action.handler = { [weak self] _, indexPath in
            print("press")
        }
        return action
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        editActionsOptionsForItemAt indexPath: IndexPath,
                        for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .border
        options.minimumButtonWidth = 110
        options.maximumButtonWidth = 110
        options.buttonSpacing = 10

        options.expansionStyle = .selection

        return options
    }
}
