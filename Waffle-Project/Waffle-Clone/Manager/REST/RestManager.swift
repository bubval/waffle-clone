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
    
    public func get(url: String, parameters: [String : String]? = nil, headers: [String : String]? = nil, completion: @escaping RestManagerCompletion) {
        let request = Request(url: url, method: .GET, parameters: parameters, headers: headers, body: nil)
        let builtRequest = request.request()
        if let urlRequest = builtRequest.request {
            let task = session.dataTask(with: urlRequest, completionHandler: completion)
            task.resume()
        } else {
            completion(nil, nil, builtRequest.error)
        }
    }
}
