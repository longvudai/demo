//
//  SerializedObject.swift
//  highlight-webview
//
//  Created by Long Vu on 11/12/2020.
//

import Foundation

struct SerializedObject: Decodable {
    let highlights: [HighlightObject]
    let currentHighlight: HighlightObject?
}

struct HighlightObject: Decodable {
    let id: Int
    let start: Int
    let end: Int
    let color: String
}
