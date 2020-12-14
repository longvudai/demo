//
//  Parsing.swift
//  githubApp
//
//  Created by Long Vu on 13/12/2020.
//

import Foundation
import Combine

func fetch(with urlRequest: URLRequest?, session: URLSession = .shared) -> AnyPublisher<Data, NetworkError> {
    guard let urlRequest = urlRequest else {
        let error = NetworkError.badRequest("Couldn't create URL request")
        return Fail(error: error).eraseToAnyPublisher()
    }

    return session.dataTaskPublisher(for: urlRequest)
        .mapError { _ in NetworkError.unknown }
        .flatMap { output -> AnyPublisher<Data, NetworkError> in
            guard let response = output.response as? HTTPURLResponse else {
                return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
            }
            switch response.statusCode {
            case 200...299:
                return Just(output.data).mapError { _ in NetworkError.noData }.eraseToAnyPublisher()
            case 400...499:
                return Fail(error: NetworkError.badRequest("\(response.statusCode) bad request")).eraseToAnyPublisher()
            case 500...599:
                return Fail(error: NetworkError.serverError("\(response.statusCode) Server error")).eraseToAnyPublisher()
            default:
                return Fail(error: NetworkError.unknown).eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
}

func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, NetworkError> {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970

    return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { .parseError($0.localizedDescription) }
        .eraseToAnyPublisher()
}

func fetch<T: Decodable>(with urlRequest: URLRequest?, session: URLSession = .shared) -> AnyPublisher<T, NetworkError> {
    return fetch(with: urlRequest).flatMap { decode($0) }.eraseToAnyPublisher()
}
