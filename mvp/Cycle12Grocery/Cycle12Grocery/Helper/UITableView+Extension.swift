//
//  UITableView+Extension.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/21/21.
//

import Foundation
import UIKit

public protocol ReusableView: AnyObject { }

extension ReusableView where Self: UIView {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
  
    public static var hasNib: Bool {
        return Bundle.main.path(forResource: self.reuseIdentifier, ofType: "nib") != nil
    }
    
    public static var nib: UINib {
        return UINib(nibName: self.reuseIdentifier, bundle: nil)
    }
}

extension UITableViewCell: ReusableView { }
extension UITableViewHeaderFooterView: ReusableView { }

extension UITableView {
    
    public func register<T: UITableViewCell>(_ cellClass: T.Type) {
        if cellClass.hasNib {
            self.register(cellClass.nib, forCellReuseIdentifier: cellClass.reuseIdentifier)
        } else {
            self.register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
        }
    }
  
    public func cellForRow<T: UITableViewCell>(at indexPath: IndexPath) -> T {
        guard let cell = cellForRow(at: indexPath) as? T else {
            fatalError("Count not downcast to \(String(describing: T.self))")
        }
        return cell
    }
  
    public func register<T: UITableViewHeaderFooterView>(aClass: T.Type) {
        register(aClass, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
  
    public func dequeueResuableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue header/footer view with identifier: \(T.reuseIdentifier)")
        }
        return view
    }
}
