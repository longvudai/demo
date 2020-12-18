//
//  RequestProtocol.swift
//  githubApp
//
//  Created by Long Vu on 14/12/2020.
//

import Foundation

protocol EnvironmentProtocol {
    var headers: RequestHeaders? { get }

    /// The base URL of the environment.
    var baseURL: String { get }
}

enum RequestType {
    case data
    case download
    case upload
}

enum RequestBodyType {
    case json
    case formData
}

enum ResponseType {
    case json
    case file
}

// HTTP request methods.
enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

typealias RequestHeaders = [String: String]

// Used for query parameters for GET requests and in the HTTP body for POST, PUT and PATCH requests.
typealias RequestParameters = [String: Any?]

// used for the HTTP request download/upload progress.
typealias ProgressHandler = (Float) -> Void

// MARK: - Request Protocol
protocol RequestProtocol {
    var path: String { get }

    var method: RequestMethod { get }

    var headers: RequestHeaders? { get }

    var parameters: RequestParameters? { get }

    var requestType: RequestType { get }

    var responseType: ResponseType { get }
    
    var requestBodyType: RequestBodyType { get }
}

extension RequestProtocol {
    public func urlRequest(with environment: EnvironmentProtocol) -> URLRequest? {
        guard let url = url(with: environment.baseURL) else {
            return nil
        }
        
        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = requestBody

        return request
    }

    private func url(with baseURL: String) -> URL? {
        // Create a URLComponents instance to compose the url.
        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }
        
        urlComponents.path += path
        urlComponents.queryItems = queryItems

        return urlComponents.url
    }

    private var queryItems: [URLQueryItem]? {
        // Chek if it is a GET method.
        guard method == .get, let parameters = parameters else {
            return nil
        }
        // Convert parameters to query items.
        return parameters.compactMap {
            guard let value = $0.value else { return nil }
            let valueString = String(describing: value)
            return URLQueryItem(name: $0.key, value: valueString)
        }
    }

    private func toFormData(params: [String: Any?]) -> String {
        return params.map { String($0.key + "=\($0.value ?? "")") }.joined(separator: "&")
    }

    private var requestBody: Data? {
        // The body data should be used for POST, PUT and PATCH only
        guard [.post, .put, .patch].contains(method), let parameters = parameters else {
            return nil
        }
        
        switch requestBodyType {
        case .json:
            return try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        case .formData:
            return toFormData(params: parameters).data(using: .utf8)
        }
    }
}
