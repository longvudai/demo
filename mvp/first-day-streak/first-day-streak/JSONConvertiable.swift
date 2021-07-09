//
//  JSONConvertiable.swift
//  first-day-streak
//
//  Created by long vu unstatic on 7/9/21.
//

import Foundation
import SwiftyJSON

protocol JSONCovertible {
    static func from(_ json: JSON) throws -> Self
}
