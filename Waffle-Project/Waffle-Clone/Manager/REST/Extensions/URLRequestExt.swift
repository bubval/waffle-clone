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
        
        var url: URL? {
            if let parameters = parameters,
                var components = URLComponents(string: url) {
                components.queryItems = parameters.map { element in URLQueryItem(name: element.key, value: element.value) }
                return URL(string: components.url!.absoluteString)
            }
            return URL(string: url)
        }
                
        if let url = url {
            var request = URLRequest(url: url)
            if let headers = headers {
                for headerKey in headers.keys {
                    request.addValue(headers[headerKey]!, forHTTPHeaderField: headerKey)
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
