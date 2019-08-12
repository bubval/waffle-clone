//
//  UserResponse.swift
//  Waffle-Clone
//
//  Created by Lubo on 29.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

struct UserResponse: Codable {
    let login: String
    let id: Int
    let avatarUrl: String
    let name: String?
    let email: String?
    let bio: String?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarUrl = "avatar_url"
        case name
        case email
        case bio
        case createdAt = "created_at"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        login = try values.decode(String.self, forKey: .login)
        id = try values.decode(Int.self, forKey: .id)
        avatarUrl = try values.decode(String.self, forKey: .avatarUrl)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        bio = try values.decodeIfPresent(String.self, forKey: .bio)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
    }
}
