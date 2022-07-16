//
//  ShareQuoteViewModel.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 6/28/21.
//

import Foundation
import Combine
import UIKit

class ShareQuoteViewModel {
    var quote: Quote?
    
    var quoteColor: AnyPublisher<QuoteColor, Never> { quoteColorSubject.eraseToAnyPublisher() }
    private var quoteColorSubject = CurrentValueSubject<QuoteColor, Never>(.orange)
    
    var items = [
        ColorSelectorCollectionView.Item(colorSet: QuoteColor.orange),
        ColorSelectorCollectionView.Item(colorSet: QuoteColor.green),
        ColorSelectorCollectionView.Item(colorSet: QuoteColor.purple),
        ColorSelectorCollectionView.Item(colorSet: QuoteColor.red),
        ColorSelectorCollectionView.Item(colorSet: QuoteColor.blue)
    ]
    
    init(quote: Quote? = nil) {
        self.quote = quote
    }
    
    func changeQuoteColor(index: Int) {
        guard index > 0 && index < items.count else {
            print("Index is out of range in items array!")
            return
        }
        let color = items[index].colorSet
        quoteColorSubject.send(color)
    }
}
