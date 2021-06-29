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
    
    static func mockListQuote() -> [Quote] {
        return [
            Quote(content: "Discipline is choosing between what you want now and what you want most", author: "― Abraham Lincoln"),
            Quote(content: "Kindness is universal. Sometimes being kind allows others to see the goodness in humanity through you. Always be kinder than necessary.", author: "― Germany Kent"),
            Quote(content: "Hide yourself in God, so when a man wants to find you he will have to go there first.", author: "― Shannon L. Alder"),
            Quote(content: "If you would convince a man that he does wrong, do right. But do not care to convince him. Men will believe what they see. Let them see.", author: "― Henry David Thoreau"),
        ]
    }
}
