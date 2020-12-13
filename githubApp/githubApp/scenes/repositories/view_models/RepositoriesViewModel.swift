//
//  RepositoriesViewModel.swift
//  githubApp
//
//  Created by Long Vu on 12/12/2020.
//

import Foundation
import Combine

class RepositoriesViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    
    init(repositories: [Repository] = []) {
        self.repositories = repositories
    }
    
    func remove(atOffsets indexSet: IndexSet) {
        repositories.remove(atOffsets: indexSet)
    }
}
