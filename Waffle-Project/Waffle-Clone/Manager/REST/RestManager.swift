//
//  RestManager.swift
//  Waffle-Clone
//
//  Created by Lubo on 22.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

public typealias RestManagerCompletion = (Data?, URLResponse?, Error?) -> Swift.Void
public typealias RestManagerResult = SynchronousDataTaskResult

open class RestManager {
    
    var session: URLSession
    
    public init() {
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    public init(session: URLSession) {
        self.session = session
    }
    
    /// Used to retrieve information from a given server. Using GET only retrieves data and has no effect on the data.
    ///
    /// - Parameters:
    ///   - url: API HTTP address
    ///   - parameters: HTTP request with a query that specifies [name : value] pairs
    ///   - headers: HTTP request for metadata
    ///   - completion: Data, URLResponse, Error
    public func get(url: String, parameters: [String : String]? = nil, headers: [String : String]? = nil, completion: @escaping RestManagerCompletion) {
        let request = Request(url: url, method: .GET, parameters: parameters, headers: headers, body: nil)
        let buildRequest = request.request()
        if let urlRequest = buildRequest.request {
            let task = session.dataTask(with: urlRequest, completionHandler: completion)
            task.resume()
        } else {
            completion(nil, nil, buildRequest.error)
        }
    }
    
    /// Used to retrieve information from a given server. Using GET only retrieves data and has no effect on the data.
    ///
    /// - Parameters:
    ///   - url: API HTTP address
    ///   - parameters: HTTP request with a query that specifies [name : value] pairs
    ///   - headers: HTTP request for metadata
    /// - Returns: Data, URLResponse, Error
    public func get(url: String, parameters: [String : String]? = nil, headers: [String: String]? = nil) -> RestManagerResult {
        let request = Request(url: url, method: .GET, parameters: parameters, headers: headers, body: nil)
        let buildRequest = request.request()
        if let urlRequest = buildRequest.request {
            return session.synchronousDataTask(request: urlRequest)
        } else {
            return (nil, nil, buildRequest.error)
        }
    }
    
    
}
