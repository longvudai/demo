//
//  TemporaryImageCached.swift
//  githubApp
//
//  Created by Long Vu on 13/12/2020.
//

import Foundation
import SwiftUI
import Combine

struct TemporaryImageCache {
    private let cache = NSCache<NSURL, UIImage>()

    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set {
            let key = key as NSURL
            newValue == nil ? cache.removeObject(forKey: key) : cache.setObject(newValue!, forKey: key) }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue = TemporaryImageCache()
}

extension EnvironmentValues {
    var temporaryImageCache: TemporaryImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
