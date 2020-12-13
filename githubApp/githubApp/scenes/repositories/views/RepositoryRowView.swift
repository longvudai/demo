//
//  RepositoryRowView.swift
//  githubApp
//
//  Created by Long Vu on 12/12/2020.
//

import SwiftUI

struct RepositoryRowView: View {
    let viewModel: RepositoryRowViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                RemoteImage(url: viewModel.avatarUrl) {
                    Image(systemName: "photo").resizable()
                }
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .padding()
                .frame(width: geometry.size.height, height: geometry.size.height)
                    
                VStack(alignment: .leading) {
                    Text(viewModel.username).frame(maxHeight: .infinity)
                    Text(viewModel.repositoryName).frame(maxHeight: .infinity)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
    }
}

struct RepositoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryRowView(viewModel: RepositoryRowViewModel(repository: mockRepository))
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
