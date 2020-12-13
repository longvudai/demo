//
//  RemoteImage.swift
//  githubApp
//
//  Created by Long Vu on 12/12/2020.
//

import Foundation
import SwiftUI
import Combine

struct RemoteImage<PlaceholderView: View, ImageView: View>: View {
    typealias RemoteImageHandler = (UIImage) -> ImageView
    private var placeholder: PlaceholderView
    private var remoteImage: RemoteImageHandler?
    
    @ObservedObject private var imageFetcher: ImageFetcher
    
    init(
        url: URL?,
        @ViewBuilder placeholder: () -> PlaceholderView,
        @ViewBuilder remoteImage: @escaping RemoteImageHandler
    ) {
        self.placeholder = placeholder()
        self.remoteImage = remoteImage
        _imageFetcher = ObservedObject(wrappedValue: ImageFetcher(url: url, cache: Environment(\.temporaryImageCache).wrappedValue))
    }
    
    var body: some View {
        if let uiImage = imageFetcher.image, let remoteImage = remoteImage {
            remoteImage(uiImage)
        } else {
            placeholder
        }
    }
}
