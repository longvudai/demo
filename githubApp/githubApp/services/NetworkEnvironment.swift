//
//  NetworkEnvironment.swift
//  githubApp
//
//  Created by Long Vu on 14/12/2020.
//

import Foundation

enum NetworkEnvironment: EnvironmentProtocol {
    case production
    
    var baseURL: String {
        switch self {
        case .production:
            return "https://api.github.com"
        }
    }
    
    var headers: RequestHeaders? {
        return nil
    }
}

let env = NetworkEnvironment.production
