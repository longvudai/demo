//
//  QuoteColor+UIKit.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/29/21.
//

import Foundation
import UIKit

extension QuoteColor {
    var value: UIColor {
        UIColor(hexString: rawValue) ?? UIColor()
    }
    
    var bgColor: UIColor {
        return value.withAlphaComponent(0.1)
    }
}
