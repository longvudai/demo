//
//  Repository.swift
//  githubApp
//
//  Created by Long Vu on 12/12/2020.
//

import Foundation

struct Repository: Decodable {
    let id: Int
    let name: String
    let fullName: String
    let isPrivate: Bool
    
    let owner: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case isPrivate = "private"
        case owner
    }
    
    enum Kind: String {
        case all, owner, member
    }
    
    enum Sort: String {
        case created, updated, pushed, full_name
    }
}

let mockRepository = Repository(id: 1296269, name: "Hello-World", fullName: "octocat/Hello-World", isPrivate: false, owner: mockUser)
