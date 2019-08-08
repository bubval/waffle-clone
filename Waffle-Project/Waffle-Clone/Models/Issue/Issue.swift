//
//  GenerateIssue.swift
//  Waffle-Clone
//
//  Created by Lubo on 8.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

struct Issue: Codable {
    let title: String
    let body: String
    let labels: [String]?
    let assignees: [String]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case labels
        case assignees
    }
    
    public init(title: String, body: String, labels: [String]?, assignees: [String]?) {
        self.title = title
        self.body = body
        self.labels = labels
        self.assignees = assignees
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        body = try values.decode(String.self, forKey: .body)
        labels = try values.decodeIfPresent([String].self, forKey: .labels)
        assignees = try values.decodeIfPresent([String].self, forKey: .assignees)
    }
}
