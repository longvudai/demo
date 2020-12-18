//
//  ImageFetcher.swift
//  githubApp
//
//  Created by Long Vu on 13/12/2020.
//

import Foundation
import Combine
import UIKit

class ImageFetcher: ObservableObject {
    @Published var image: UIImage?

    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    private var url: URL?
    private var cache: TemporaryImageCache?
    private var cancellable: AnyCancellable?
    
    // MARK: - Initialization
    init(url: URL?, cache: TemporaryImageCache? = nil) {
        self.url = url
        self.cache = cache
        fetch()
    }
    
    deinit {
        cancel()
    }
    
    func fetch() {
        guard let url = url else { return }
        
        if let cache = cache, let image = cache[url] {
            self.image = image
        } else {
            cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: ImageFetcher.imageProcessingQueue)
                .map { output -> UIImage? in
                    return UIImage(data: output.data)
                }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    // caching image
                    guard let weakSelf = self else { return }
                    weakSelf.cache?[url] = $0
                    weakSelf.image = $0
                }
        }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
