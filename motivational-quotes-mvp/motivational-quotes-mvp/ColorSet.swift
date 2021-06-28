//
//  ColorSet.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/28/21.
//

import Foundation
import UIKit

enum ColorSet: String {
    case orange,
    purple,
    blue,
    green,
    red
    
    var value: UIColor {
        UIColor(named: rawValue) ?? UIColor()
    }
    
    var bgColor: UIColor {
        return value.withAlphaComponent(0.1)
    }
}
