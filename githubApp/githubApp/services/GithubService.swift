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
    func fetchListRepositoriesForUser(_ username: String) -> AnyPublisher<[Repository], NetworkError> {
        let request = GithubEndpoint.Repositories.listForUser(username).urlRequest(with: environment)
        return fetch(with: request)
    }
}
