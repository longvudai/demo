//
//  ViewController.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/9/21.
//

import UIKit
import SwipeCellKit
import SnapKit
import SwiftUIX
import FloatingPanel

class ViewController: UIViewController {
    var dataSource: UICollectionViewDiffableDataSource<String, Habit>?
    
    lazy var dateSelectorView: UIHostingView<DateSelectorView> = {
        let tomorrow = Calendar.current.date(byAdding: .day,value: 1, to: Date())!
        let thisDayLastMonth = Calendar.current.date(byAdding: .month, value: -1, to: tomorrow)!
        let dateInterval = DateInterval(start: thisDayLastMonth, end: tomorrow)
        return UIHostingView(rootView: DateSelectorView(dateInterval: dateInterval))
    }()
    
//    lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
//            let itemSize = NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1),
//                heightDimension: .estimated(100)
//            )
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//            
//            let groupSize = NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1),
//                heightDimension: .estimated(100)
//            )
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//            return NSCollectionLayoutSection(group: group)
//        }
//        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        
//        v.register(HabitCollectionViewCell2.self, forCellWithReuseIdentifier: "habit-cell2")
//        
//        v.delegate = self
//        
//        v.backgroundColor = .lightGray
//        return v
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = Colors.background
        navigationBar.backgroundColor = Colors.background
        navigationBar.isTranslucent = false
        
        setupView()
        
//        dataSource = UICollectionViewDiffableDataSource<String, Habit>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habit-cell2", for: indexPath) as! HabitCollectionViewCell2
//            cell.delegate = self
//
//
//            cell.habitTitle = item.title
//            cell.goalString = "\(item.currentValue) / \(item.targetValue) mins"
//            cell.goalProgress = CGFloat (item.currentValue / item.targetValue)
//            cell.habitIconName = item.habitIconName
//
//            return cell
//        }
//
//        collectionView.dataSource = dataSource
//
//        var snapshot = NSDiffableDataSourceSnapshot<String, Habit>.init()
//        snapshot.appendSections(["Section 1", "Section 2"])
//
//        let items = [
//            Habit.mockedValue1,
//            Habit.mockedValue2
//        ]
//        snapshot.appendItems(items, toSection: "Section 1")
//        dataSource?.apply(snapshot)
    }
    
    private lazy var iconSelectButton: UIButton = {
        let v = UIButton()
        v.setTitleColor(.black, for: .normal)
        v.setTitle("Icon Select", for: .normal)
        v.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return v
    }()
    
    private func setupView() {
//        view.addSubview(collectionView)
//        collectionView.snp.makeConstraints {
//            $0.edges.equalTo(view.safeAreaLayoutGuide)
//        }
        
//        let viewModel = JournalSettingViewModel()
//        let v = JournalSettingView(viewModel: viewModel)
//        UIHostingView<JournalSettingView>(rootView: v)
        let contentView = iconSelectButton
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
//            $0.trailing.equalToSuperview().inset(100)
//            $0.center.equalToSuperview()
        }
    }
    
    @objc private func handleTap() {
//        let c = HabitIconPickerController(selectedColor: .red, selectedIconName: nil)
//        let navigationControllerWrapper = UINavigationController(rootViewController: c)
//        navigationControllerWrapper.navigationBar.backgroundColor = Colors.groupedSecondaryBackground
//        navigationControllerWrapper.navigationBar.barTintColor = Colors.groupedSecondaryBackground
//        present(navigationControllerWrapper, animated: true, completion: nil)
        
        let fpc = FloatingPanelController()
        fpc.layout = JournalOptionController.JournalOptionFloatingPanelLayout()
        fpc.surfaceView.appearance.cornerRadius = 10
        fpc.surfaceView.contentPadding = .init(top: 24, left: 0, bottom: 0, right: 0)
        fpc.surfaceView.backgroundColor = Colors.secondaryBackground

//        fpc.delegate = self // Optional
        
        fpc.isRemovalInteractionEnabled = true

        // Set a content view controller.
        let contentVC = JournalOptionController()
        let navigationWrapper = UINavigationController(rootViewController: contentVC)
        
        fpc.set(contentViewController: navigationWrapper)
        present(fpc, animated: true, completion: nil)
    }
}

//extension ViewController: UICollectionViewDelegate, SwipeCollectionViewCellDelegate {
//    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        switch orientation {
//        case .left:
//            return [checkinAction()]
//        case .right:
//            return [addNoteAction()]
//        }
//    }
//
//    private func checkinAction() -> SwipeAction {
//        let action = SwipeAction(style: .destructive, title: "Completed", handler: nil)
//        action.font =  .systemFont(ofSize: 13, weight: .medium)
//        action.textColor = .white
//        action.image = PlatformImage(named: "JournalSwipeCheckin")
//        action.hidesWhenSelected = true
//        action.backgroundColor = Colors.accentPrimary
//        action.handler = { [weak self] _, indexPath in
//            print("press")
//        }
//        return action
//    }
//
//    private func addNoteAction() -> SwipeAction {
//        let action = SwipeAction(style: .default, title: "Note", handler: nil)
//        action.font =  .systemFont(ofSize: 13, weight: .medium)
//        action.textColor = actionForegroundColor
//        action.image = PlatformImage(named: "JournalSwipeAddNote")
//        action.hidesWhenSelected = true
//        action.backgroundColor = Colors.secondaryBackground
//        action.handler = { [weak self] _, indexPath in
//
//        }
//        return action
//    }
//
//    private var actionBackgroundColor: UIColor {
//        return Colors.secondaryBackground
//    }
//
//    private var actionForegroundColor: UIColor {
//        return UIColor(dynamicProvider: { traitCollection -> UIColor in
//            switch traitCollection.userInterfaceStyle {
//            case .dark:
//                return .white
//
//            case .light, .unspecified:
//                return Colors.accentPrimary
//            @unknown default:
//                return Colors.accentPrimary
//            }
//        })
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        editActionsOptionsForItemAt indexPath: IndexPath,
//                        for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.transitionStyle = .border
//        options.minimumButtonWidth = 90
//        options.expansionStyle = .selection
//
//        return options
//    }
//}

//extension ViewController: FloatingPanelControllerDelegate {
////    func floatingPanelShouldBeginDragging(_ fpc: FloatingPanelController) -> Bool {
////        return fpc.state != .full
////    }
//
//    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
//        fpc.panGestureRecognizer.isEnabled = fpc.state != .full
//    }
//}
