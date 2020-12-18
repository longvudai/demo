//
//  GithubService.swift
//  githubApp
//
//  Created by Long Vu on 14/12/2020.
//

import Foundation
import Combine

class GithubService {
    static let shared = GithubService(environment: env)
    private let session: URLSession
    private var environment: EnvironmentProtocol
    private init(environment: EnvironmentProtocol, session: URLSession = .shared) {
        self.environment = environment
        self.session = session
    }
    
    // MARK: - Helper functions
    func changeEnvironment(_ env: EnvironmentProtocol) {
        environment = env
    }
    
    // MARK: - the api lists
    func fetchListRepositoriesForUser(_ username: String, type: Repository.Kind = .all, sort: Repository.Sort = .created, direction: Direction = .asc) -> AnyPublisher<[Repository], NetworkError> {
        let endpoint = GithubEndpoint.Repositories.listForUser(username: username, type: type, sort: sort, direction: direction)
        let urlRequest = endpoint.urlRequest(with: environment)
        return fetch(with: urlRequest)
    }
}
