//
//  Highlight.swift
//  highlight-webview
//
//  Created by Long Vu on 11/12/2020.
//

import Foundation

struct Highlight: Codable {
    let id: Int
    let color: Int
    let start: Int
    let end: Int
    let data: Data
}

extension Highlight: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

typealias Highlights = [Highlight]
