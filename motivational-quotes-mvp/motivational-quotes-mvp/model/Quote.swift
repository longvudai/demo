//
//  Quote.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/28/21.
//

import Foundation

struct Quote {
    let content: String
    let author: String
    var hashTag: String = "#Habitify"
}

extension Quote {
    static func mockQuote() -> Quote {
        return Quote(content: "Discipline is choosing between what you want now and what you want most", author: "― Abraham Lincoln")
    }
}
