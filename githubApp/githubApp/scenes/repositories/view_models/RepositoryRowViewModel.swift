//
//  RepositoryRowViewModel.swift
//  githubApp
//
//  Created by Long Vu on 12/12/2020.
//

import Foundation

class RepositoryRowViewModel {
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    var repositoryName: String {
        return repository.name
    }
    
    var username: String {
        return repository.owner.login
    }
    
    var avatarUrl: URL? {
        return URL(string: repository.owner.avatarUrl)
    }
}
