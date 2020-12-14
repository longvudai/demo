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
        case listForUser(String)
        
        var path: String {
            switch self {
            case .listForUser(let user):
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
            return nil
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
