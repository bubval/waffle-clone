//
//  RepositoryResponse.swift
//  Waffle-Clone
//
//  Created by Lubo on 29.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

public struct RepositoryResponse: Codable {
    let id: Int
    let name: String
    let description: String
    let url: String
    let createdAt: String
    let updatedAt: String
    let hasIssues: Bool
    let homepage: String
    let isPrivate: Bool
    let owner: RepoCreator?
    let organization: RepoCreator?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case url
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case hasIssues = "has_issues"
        case homepage
        case isPrivate = "private"
        case owner
        case organization
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        url = try values.decode(String.self, forKey: .url)
        createdAt = try values.decode(String.self, forKey: .createdAt)
        updatedAt = try values.decode(String.self, forKey: .updatedAt)
        hasIssues = try values.decode(Bool.self, forKey: .hasIssues)
        homepage = try values.decode(String.self, forKey: .homepage)
        isPrivate = try values.decode(Bool.self, forKey: .isPrivate)
        owner = try values.decodeIfPresent(RepoCreator.self, forKey: .owner)
        organization = try values.decodeIfPresent(RepoCreator.self, forKey: .organization)
    }
}
