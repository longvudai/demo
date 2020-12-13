//
//  RemoteImage.swift
//  githubApp
//
//  Created by Long Vu on 12/12/2020.
//

import Foundation
import SwiftUI
import Combine

struct RemoteImage<PlaceholderView: View>: View {
    private var placeholder: PlaceholderView
    @ObservedObject private var imageFetcher: ImageFetcher
    
    init(url: URL?, @ViewBuilder placeholder: () -> PlaceholderView) {
        self.placeholder = placeholder()
        _imageFetcher = ObservedObject(wrappedValue: ImageFetcher(url: url, cache: Environment(\.temporaryImageCache).wrappedValue))
    }
    
    var body: some View {
        if let uiImage = imageFetcher.image {
            Image(uiImage: uiImage).resizable()
        } else {
            placeholder
        }
    }
}
