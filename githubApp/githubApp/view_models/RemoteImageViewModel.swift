//
//  RemoteImageViewModel.swift
//  githubApp
//
//  Created by Long Vu on 13/12/2020.
//

import Foundation
import UIKit
import Combine
import SwiftUI

class RemoteImageViewModel: ObservableObject {
    @Published var image: UIImage?
    
    private var imageFetcher: ImageFetcher
    private var cancellable: AnyCancellable?
    
    init(url: URL?, cache: TemporaryImageCache? = nil) {
        self.imageFetcher = ImageFetcher(url: url, cache: cache)
        cancellable = imageFetcher.$image.sink { [weak self] in
            self?.image = $0
        }
    }
    
    deinit {
        imageFetcher.cancel()
    }
}
