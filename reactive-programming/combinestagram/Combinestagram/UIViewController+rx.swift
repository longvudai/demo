//
//  UIViewController+Ex.swift
//  Combinestagram
//
//  Created by Long Vu on 7/11/21.
//  Copyright © 2021 Underplot ltd. All rights reserved.
//

import Foundation
import UIKit.UIViewController
import RxSwift

extension UIViewController {
  func alert(_ title: String, description: String? = nil) -> Completable {
    return Completable.create { [unowned self] observer in
      let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
        observer(.completed)
      }))
      self.present(alert, animated: true, completion: nil)
      return Disposables.create {
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
}
