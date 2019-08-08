//
//  RepoCreator.swift
//  Waffle-Clone
//
//  Created by Lubo on 29.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

public struct BasicUserResponse: Codable {
    let login: String
    let id: Int
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarUrl = "avatar_url"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        login = try values.decode(String.self, forKey: .login)
        id = try values.decode(Int.self, forKey: .id)
        avatarUrl = try values.decode(String.self, forKey: .avatarUrl)
    }
}
