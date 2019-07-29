//
//  IssueLabel.swift
//  Waffle-Clone
//
//  Created by Lubo on 29.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

public struct IssueLabel: Codable {
    let id: Int
    let name: String
    let description: String
    let color: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case color
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        color = try values.decode(String.self, forKey: .color)
    }
}
