//
//  JournalReorderController.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/21/21.
//

import Foundation
import SwiftUI
import SwiftUIX
import UIKit

private protocol SortableItem {
    var title: String { get }
    var iconName: String { get }
    var accentColorHex: String { get }
}

private struct Item: SortableItem {
    var title: String
    var iconName: String
    var accentColorHex: String
}
private extension Item {
    static let mockValue: Item = Item(title: "Mediate", iconName: ImageAsset.icon1.rawValue, accentColorHex: "#119F39")
}

class JournalReorderController: UIViewController {
    // MARK: - UI Properties

    private lazy var tableView: TableView = {
        let v = TableView(frame: .zero, style: .insetGrouped)
        
        v.delegate = self
        v.dataSource = self
        
        v.register(TableView.Cell.self)
        
        v.contentInset = .init(horizontal: 0, vertical: 16)
        v.rowHeight = UITableView.automaticDimension
        v.estimatedRowHeight = 70
        v.separatorInset = UIEdgeInsets(top: 0, left: 76, bottom: 0, right: 0)
        v.isEditing = true
        
        return v
    }()
    
    // MARK: - Properties

    private var items: [SortableItem] = Array<Item>.init(repeating: Item.mockValue, count: 20)
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupView()
        setupConstraints()
    }
    
    private func setupNavigationController() {
        title = "Reorder"
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
}

// MARK: - TableView Delegate

extension JournalReorderController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

// MARK: - TableView Datasource

extension JournalReorderController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableView.Cell = tableView.dequeueResuableCell(forIndexPath: indexPath)
        let data = items[indexPath.row]
        cell.configure(title: data.title, imageName: data.iconName, accentColorHex: data.accentColorHex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: .zero)
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = items[sourceIndexPath.row]
        items.remove(at: sourceIndexPath.row)
        items.insert(movedObject, at: destinationIndexPath.row)
    }
    
    // disable indent and edit icon
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - Components

extension JournalReorderController {
    class TableView: UITableView {}
}

extension JournalReorderController.TableView {
    class Cell: UITableViewCell {
        private lazy var iconView: UIImageView = {
            let v = UIImageView()
            v.setContentHuggingPriority(.required, for: .horizontal)
            return v
        }()
        
        private lazy var titleView: UILabel = {
            let v = UILabel()
            v.font = AppTextStyles.title3.font
            v.textColor = Colors.labelPrimary
            return v
        }()
        private var didMakeIconRounded = false
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            let views = [iconView, titleView]
            views.forEach { contentView.addSubview($0) }
            
            iconView.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(16)
                $0.height.equalTo(40)
                $0.width.equalTo(iconView.snp.height)
                $0.bottom.top.equalToSuperview().inset(13).priority(.high)
            }
            
            titleView.snp.makeConstraints {
                $0.leading.equalTo(iconView.snp.trailing).offset(20)
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(16)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            if !iconView.frame.isEmpty && !didMakeIconRounded {
                iconView.makeRounded()
                didMakeIconRounded = true
            }
        }
        
        func configure(title: String, imageName: String, accentColorHex: String) {
            tintColor = UIColor(hexRGB: accentColorHex)
            iconView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            titleView.text = title
        }
    }

}

private extension UIImageView {
    func makeRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        layer.backgroundColor = tintColor.withAlphaComponent(0.1).cgColor
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = self.frame.height / 2
    }
}
