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
    
    /// Adds parameters to URL, then creates a URLRequest from URL.
    /// Adds headers, httpMethod, and httpBody to URLRequest.
    ///
    /// - Parameter path: String URL
    /// - Returns: URLRequest with parameters, headers, httpMethod, and body
    public func get(path: String? = nil) -> (urlRequest: URLRequest?, error: Error?) {
        let url = URL(string: path ?? self.construct(url: self.url, with: self.parameters))
        
        if let url = url {
            var request = URLRequest(url: url)
            if let headers = headers {
                for headerKey in headers.keys {
                    request.addValue(headers[headerKey]!, forHTTPHeaderField: headerKey)
                }
            }
            request.httpMethod = method.rawValue
            request.httpBody = body
            return(request, nil)
        } else {
            return(nil, "Unable to create URL")
        }
    }
    
    private func construct(url retrievedURL: String, with parameters: [String : String]?) -> String {
        var retrievedURL = retrievedURL
        if let parameters = parameters,
            parameters.count > 0 {
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
        return retrievedURL
    }
}
