//
//  GithubEndpoint.swift
//  githubApp
//
//  Created by Long Vu on 14/12/2020.
//

import Foundation
import Combine

enum GithubEndpoint {
    enum Repositories: RequestProtocol {
        case listForUser(username: String, type: Repository.Kind, sort: Repository.Sort, direction: Direction = .asc)
        
        var path: String {
            switch self {
            case let .listForUser(user, _, _, _):
                return "/users/\(user)/repos"
            }
        }
        
        var method: RequestMethod {
            switch self {
            case .listForUser:
                return .get
            }
        }
        
        var headers: RequestHeaders? {
            return ["Accept": "application/vnd.github.v3+json"]
        }
        
        var parameters: RequestParameters? {
            switch self {
            case let .listForUser(_, type, sort, direction):
                return ["type": type.rawValue, "sort": sort.rawValue, "direction": direction.rawValue]
            }
        }
        
        var requestType: RequestType {
            return .data
        }
        
        var responseType: ResponseType {
            return .json
        }
        
        var requestBodyType: RequestBodyType {
            return .json
        }
    }
}
