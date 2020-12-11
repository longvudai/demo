//
//  MarkerColor.swift
//  highlight-webview
//
//  Created by Long Vu on 11/12/2020.
//

import UIKit

enum MarkerColor: String {
    case orange, cyan, pink
    
    var value: UIColor {
        switch self {
        case .orange:
            return UIColor(named: "orange")!
        case .cyan:
            return UIColor(named: "cyan")!
        case .pink:
            return UIColor(named: "pink")!
        }
    }
}
