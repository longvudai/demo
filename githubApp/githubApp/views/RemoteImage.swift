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
    
    @ObservedObject var viewModel: RemoteImageViewModel
    
    init(
        viewModel: RemoteImageViewModel,
        @ViewBuilder placeholder: () -> PlaceholderView,
        @ViewBuilder remoteImage: @escaping RemoteImageHandler
    ) {
        self.viewModel = viewModel
        self.placeholder = placeholder()
        self.remoteImage = remoteImage
    }
    
    var body: some View {
        if let uiImage = viewModel.image, let remoteImage = remoteImage {
            remoteImage(uiImage)
        } else {
            placeholder
        }
    }
}
