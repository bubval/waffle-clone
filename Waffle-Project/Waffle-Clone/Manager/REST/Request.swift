//
//  Request.swift
//  Waffle-Clone
//
//  Created by Lubo on 22.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

public class Request {
    public var url: String
    public var method: RequestMethod
    public var parameters: [String : String]?
    public var headers: [String : String]?
    public var body: Data?
    
    public init(url: String, method: RequestMethod, parameters: [String : String]? = nil, headers: [String : String]? = nil, body: Data? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.body = body
    }
    
    func urlWithParameters() -> String {
        var retrievedURL = url
        if let parameters = parameters {
            if parameters.count > 0 {
                retrievedURL.append("?")
                parameters.keys.forEach {
                    guard let value = parameters[$0] else {
                        return
                    }
                    let escapedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.URLQueryAllowedCharacterSet())
                    if let escapedValue = escapedValue {
                        retrievedURL.append("\($0)=\(escapedValue)&")
                    }
                }
                retrievedURL.removeLast()
            }
        }
        return retrievedURL
    }
}
