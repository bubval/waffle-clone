//
//  IssueLabel.swift
//  Waffle-Clone
//
//  Created by Lubo on 29.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

public struct LabelResponse: Codable {
    let name: String
    let description: String
    let color: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case color
    }
    
    public init(name: String, description: String, color: String) {
        self.name = name
        self.description = description
        self.color = color
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        color = try values.decode(String.self, forKey: .color)
    }
}
