//
//  Repositories.swift
//  githubApp
//
//  Created by Long Vu on 12/12/2020.
//

import SwiftUI
import Combine

struct RepositoriesView: View {
    @ObservedObject var viewModel: RepositoriesViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.repositories, id: \.id) { repository in
                    NavigationLink(destination: RepositoryView()) {
                        RepositoryRowView(viewModel: RepositoryRowViewModel(repository: repository))
                        }
                }
                .onDelete(perform: { indexSet in
                    viewModel.remove(atOffsets: indexSet)
                })
                .frame(height: 80)
            }
            .navigationBarTitle(Text("Repositories"))
        }
    }
}

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesView(viewModel: RepositoriesViewModel(repositories: Array(repeating: mockRepository, count: 40)))
    }
}
