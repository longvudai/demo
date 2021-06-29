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
    var quote: Quote
    
    var quoteColor: AnyPublisher<ColorSet, Never> { quoteColorSubject.eraseToAnyPublisher() }
    private var quoteColorSubject = CurrentValueSubject<ColorSet, Never>(.orange)
    
    var items = [
        ColorSelectorCollectionView.Item(colorSet: ColorSet.orange),
        ColorSelectorCollectionView.Item(colorSet: ColorSet.green),
        ColorSelectorCollectionView.Item(colorSet: ColorSet.purple),
        ColorSelectorCollectionView.Item(colorSet: ColorSet.red),
        ColorSelectorCollectionView.Item(colorSet: ColorSet.blue)
    ]
    
    init(quote: Quote) {
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
