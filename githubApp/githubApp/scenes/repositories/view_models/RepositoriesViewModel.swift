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
    private var disposables = Set<AnyCancellable>()
    private var githubService: GithubService {
        return GithubService.shared
    }
    
    init(repositories: [Repository] = []) {
        fetchListRepositoriesForUser("longvudai")
    }
    
    deinit {
        disposables.forEach { $0.cancel() }
    }
    
    func remove(atOffsets indexSet: IndexSet) {
        repositories.remove(atOffsets: indexSet)
    }
    
    func fetchListRepositoriesForUser(_ username: String) {
        githubService.fetchListRepositoriesForUser(username, type: .all, sort: .updated)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
            guard let weakSelf = self else { return }
            switch value {
            case .failure(let error):
                print(error)
                weakSelf.repositories = []
            case .finished:
              break
            }
        } receiveValue: { [weak self] in
            self?.repositories = $0
        }.store(in: &disposables)
    }
}
