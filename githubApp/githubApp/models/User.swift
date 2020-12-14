//
//  User.swift
//  githubApp
//
//  Created by Long Vu on 12/12/2020.
//

import Foundation

struct User: Decodable {
    let id: Int
    let type: String
    let login: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case login
        case avatarUrl = "avatar_url"
    }
}

let mockUser = User(id: 1, type: "User", login: "octocat", avatarUrl: "https://avatars1.githubusercontent.com/u/583231?s=460&u=a59fef2a493e2b67dd13754231daf220c82ba84d&v=4")
