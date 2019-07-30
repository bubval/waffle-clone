//
//  URLRequest.swift
//  Waffle-Clone
//
//  Created by Lubo on 26.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

extension URLRequest {
    
    public init?(url: String, method: RequestMethod, parameters: [String : String]? = nil, headers: [String : String]? = nil, body: Data? = nil) {
        
        // Builds query url from parameters
        var url: URL? {
            if let parameters = parameters,
                var components = URLComponents(string: url) {
                components.queryItems = parameters.map { element in URLQueryItem(name: element.key, value: element.value) }
                if let componentsUrl = components.url {
                    return URL(string: componentsUrl.absoluteString)
                }
            }
            return URL(string: url)
        }
        
        // Builds urlRequest from url w/ headers, http method and body
        if let url = url {
            var request = URLRequest(url: url)
            if let headers = headers {
                for (key, value) in headers {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            request.httpMethod = method.rawValue
            request.httpBody = body
            self = request
        } else {
            return nil
        }
    }
}
