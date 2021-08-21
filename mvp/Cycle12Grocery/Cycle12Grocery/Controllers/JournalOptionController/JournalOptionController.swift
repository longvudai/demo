//
//  JournalOptionController.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/21/21.
//

import UIKit
import SnapKit
import FloatingPanel

class JournalOptionController: UIViewController {
    private(set) lazy var tableView: TableView = {
        let v = TableView(frame: .zero, style: .insetGrouped)
        
        v.delegate = self
        v.dataSource = self
        
        v.register(TableView.SelectableCell.self)
        v.register(TableView.NavigationCell.self)
        v.register(TableView.ReorderCell.self)
        v.register(TableView.SegmentedCell.self)
        
        v.separatorInset = UIEdgeInsets(top: 0, left: 54, bottom: 0, right: 0)
        v.backgroundColor = Colors.secondaryBackground
        
        return v
    }()
    
    // MARK: - Properties
    private var selectedIndexPath: IndexPath?
    private var data: [JournalOption] = [.sort(JournalSortOption.allCases), .manageArea]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationView()
        setupView()
        setupConstraints()
    }
    
    private func setupNavigationView() {
        let titleView: UILabel = {
            let v = UILabel()
            v.textColor = Colors.labelPrimary
            v.font = AppTextStyles.heading4.font
            v.text = "Journal Options"
            return v
        }()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleView)
        
        navigationController?.delegate = self
        
        if let navigationBar = navigationController?.navigationBar {
            // set appreance
            navigationBar.barTintColor = .clear
            navigationBar.backgroundColor = .clear
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.isTranslucent = true
            navigationController?.view.backgroundColor = .clear
        }
    }
    
    private func setupView() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc
    private func saveButtonTapped() {
        dismiss()
    }
}

// MARK: - NavigationDelegate
extension JournalOptionController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        UIView.preventDimmingView()
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        UIView.allowDimmingView()
    }
}

// MARK: - TableViewDelegate
extension JournalOptionController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (0..<data.count).contains(indexPath.section) else {
            return
        }
        selectedIndexPath = indexPath
        let option = data[indexPath.section]
        switch option {
        case .sort(let sortOptions):
            if (0..<sortOptions.count).contains(indexPath.row) {
                let sortOption = sortOptions[indexPath.row]
                switch sortOption {
                case .myHabitsOrder, .reminderTimeOrder, .alphabeticalOrder:
                    tableView.reloadData()
                case .reorder:
                    let reorderController = JournalReorderController()
                    navigationController?.pushViewController(reorderController, animated: true)
                case .alphabeticalOrderSegmented:
                    break
                }
            }
        case .manageArea:
            print("navigate")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - TableViewDataSource
extension JournalOptionController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (0..<data.count).contains(section) else {
            return 0
        }
        switch data[section] {
        case .sort(let sortOptions):
            return sortOptions.count
        case .manageArea:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = data[indexPath.section]
        switch option {
        case .sort(let sortOptions):
            let sortOption = sortOptions[indexPath.row]
            switch sortOption {
            case .myHabitsOrder, .reminderTimeOrder, .alphabeticalOrder:
                let cell: TableView.SelectableCell = tableView.dequeueResuableCell(forIndexPath: indexPath)
                cell.configure(title: sortOption.rawValue, icon: sortOption.icon)
                cell.isSelected = selectedIndexPath == indexPath
                return cell
            case .reorder:
                let cell: TableView.ReorderCell = tableView.dequeueResuableCell(forIndexPath: indexPath)
                cell.configure(title: sortOption.rawValue)
                return cell
            case .alphabeticalOrderSegmented:
                let cell: TableView.SegmentedCell = tableView.dequeueResuableCell(forIndexPath: indexPath)
                return cell
            }
        case .manageArea:
            let cell: TableView.NavigationCell = tableView.dequeueResuableCell(forIndexPath: indexPath)
            cell.configure(title: "Manage Area")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleView: UITextView = UITextView()
        titleView.textContainerInset = .init(top: 24, left: 0, bottom: 12, right: 0)
        titleView.font = AppTextStyles.caption1.font
        titleView.textColor = Colors.labelSecondary
        titleView.isEditable = false
        titleView.isSelectable = false
        titleView.backgroundColor = .clear
        
        switch data[section] {
        case .sort:
            titleView.text = "Sort by".uppercased()
        case .manageArea:
            titleView.text = "Areas".uppercased()
        }
        
        return titleView
    }
}

// MARK: - Components
extension JournalOptionController {
    class TableView: UITableView {}
    
    class JournalOptionFloatingPanelLayout: FloatingPanelLayout {
        let position: FloatingPanelPosition = .bottom
        let initialState: FloatingPanelState = .half
        var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
            return [
                .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
                .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            ]
        }
    }
}

private extension JournalOptionController {
    enum JournalSortOption: String, CaseIterable {
        case myHabitsOrder = "My Habits Order"
        case reorder = "Reorder..."
        case reminderTimeOrder = "Reminder Time"
        case alphabeticalOrder = "Alphabetical"
        case alphabeticalOrderSegmented
        
        static var allCases: [JournalSortOption] {
            return [
                .myHabitsOrder,
                .reorder,
                .reminderTimeOrder,
                .alphabeticalOrder,
                .alphabeticalOrderSegmented
            ]
        }
        
        var icon: UIImage? {
            switch self {
            case .myHabitsOrder:
                return UIImage(named: ImageAsset.journalOptionMyHabitsOrder.rawValue)
            case .reminderTimeOrder:
                return UIImage(named: ImageAsset.journalOptionReminderTimeOrder.rawValue)
            case .alphabeticalOrder:
                return UIImage(named: ImageAsset.journalOptionAlphabeticalOrder.rawValue)
            default:
                return nil
            }
        }
    }
    enum JournalOption {
        case sort([JournalSortOption])
        case manageArea
    }
}

// MARK: - Cell components
private extension JournalOptionController.TableView {
    class BaseTableCell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            setupView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupView() {}
    }
    
    class SegmentedCell: BaseTableCell {
        private lazy var segmentedView: UISegmentedControl = {
            let v = UISegmentedControl(items: ["A-Z","Z-A"])
            v.selectedSegmentIndex = 0
            v.addTarget(self, action: #selector(segmentedValueChange(_:)), for: .valueChanged)
            return v
        }()
        
        override func setupView() {
            contentView.addSubview(segmentedView)
            segmentedView.snp.makeConstraints {
                $0.bottom.top.trailing.equalToSuperview().inset(15)
                $0.leading.equalToSuperview().inset(145)
            }
        }
        
        @objc
        private func segmentedValueChange(_ sender: UISegmentedControl) {}
    }
    class ReorderCell: BaseTableCell {
        private lazy var titleView: UILabel = {
            let v = UILabel()
            v.font = AppTextStyles.title3.font
            v.textColor = Colors.labelPrimary
            return v
        }()
        
        override func setupView() {
            accessoryType = .disclosureIndicator
            
            let views = [titleView]
            views.forEach { contentView.addSubview($0) }
            
            titleView.snp.makeConstraints {
                $0.top.bottom.trailing.equalToSuperview().inset(18)
                $0.leading.equalToSuperview().inset(77)
            }
        }
        
        func configure(title: String) {
            titleView.text = title
        }
    }
    
    class NavigationCell: BaseTableCell {
        private lazy var titleView: UILabel = {
            let v = UILabel()
            v.font = AppTextStyles.title3.font
            v.textColor = Colors.labelPrimary
            return v
        }()
        
        override func setupView() {
            accessoryType = .disclosureIndicator
            
            let views = [titleView]
            views.forEach { contentView.addSubview($0) }
            
            titleView.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(18)
            }
        }
        
        func configure(title: String) {
            titleView.text = title
        }
    }
    
    class SelectableCell: BaseTableCell {
        private lazy var iconView: UIImageView = {
            let v = UIImageView()
            v.setContentHuggingPriority(.required, for: .horizontal)
            return v
        }()
        
        private lazy var checkmarkView: UIImageView = {
            let v = UIImageView(image: UIImage(named: ImageAsset.smartActionCompleted.rawValue))
            v.setContentHuggingPriority(.required, for: .horizontal)
            return v
        }()
        
        private lazy var titleView: UILabel = {
            let v = UILabel()
            v.font = AppTextStyles.title3.font
            v.textColor = Colors.labelPrimary
            return v
        }()
        
        override func setupView() {
            let views = [iconView, titleView]
            views.forEach { contentView.addSubview($0) }
            
            iconView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(23)
                $0.leading.equalToSuperview().inset(18)
            }
            
            titleView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(iconView.snp.trailing).offset(16)
                $0.trailing.equalToSuperview().inset(16)
            }
        }
        
        override var isSelected: Bool {
            didSet {
                if isSelected {
                    accessoryView = checkmarkView
                } else {
                    accessoryView = nil
                }
            }
        }
        
        func configure(title: String, icon: UIImage? = nil) {
            titleView.text = title
            iconView.image = icon
        }
    }
}
