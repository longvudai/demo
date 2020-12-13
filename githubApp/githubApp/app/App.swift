//
//  githubAppApp.swift
//  githubApp
//
//  Created by Long Vu on 12/12/2020.
//

import SwiftUI

@main
struct GithubApp: App {
    var body: some Scene {
        WindowGroup {
            RepositoriesView(viewModel: RepositoriesViewModel(repositories: Array(repeating: mockRepository, count: 1000)))
        }
    }
}
