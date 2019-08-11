//
//  RestManager.swift
//  Waffle-Clone
//
//  Created by Lubo on 22.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

public typealias RestManagerCompletion = (Data?, URLResponse?, Error?) -> Swift.Void

class RestManager {
    
    var session: URLSession
    
    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        self.session = session
    }
    
    /// Used to retrieve information from a given server. Using GET only retrieves data and has no effect on the data.
    ///
    /// - Parameters:
    ///   - url: HTTP address
    ///   - parameters: URL query items specified in [name : value] pairs
    ///   - headers: HTTP metadata
    ///   - completion: Data, URLResponse, Error
    func get(url: String, parameters: [String : String]? = nil, headers: [String : String]? = nil, completion: RestManagerCompletion? = nil) {
        let urlRequest = URLRequest.init(url: url, method: .GET, parameters: parameters, headers: headers, body: nil)
        if let urlRequest = urlRequest,
            let completion = completion {
            let task = session.dataTask(with: urlRequest, completionHandler: completion)
            task.resume()
        } else {
            completion?(nil, nil, RequestError.unableToBuildRequest)
        }
    }
    
    /// Used to send data to the server.
    ///
    /// - Parameters:
    ///   - url: HTTP address
    ///   - parameters: URL query items specified in [name : value] pairs
    ///   - headers: HTTP metadata
    ///   - body: data bytes transmitted in an HTTP transaction message
    ///   - completion: Data, URLResponse, Error
    func post(url: String, parameters: [String : String]? = nil, headers: [String: String]? = nil, body: Data?, completion: RestManagerCompletion? = nil) {
        let urlRequest = URLRequest.init(url: url, method: .POST, parameters: parameters, headers: headers, body: body)
        if let urlRequest = urlRequest,
            let completion = completion {
            let task = session.dataTask(with: urlRequest, completionHandler: completion)
            task.resume()
        } else {
            completion?(nil, nil, RequestError.unableToBuildRequest)
        }
    }
    
    /// Replaces all the current representations of the target resource with the uploaded content.
    ///
    /// - Parameters:
    ///   - url: HTTP address
    ///   - parameters: URL query items specified in [name : value] pairs
    ///   - headers: HTTP metadata
    ///   - body: data bytes transmitted in an HTTP transaction message
    ///   - completion: Data, URLResponse, Error
    func put(url: String, parameters: [String : String]? = nil, headers: [String: String]? = nil, body: Data?, completion: RestManagerCompletion? = nil) {
        let urlRequest = URLRequest.init(url: url, method: .PUT, parameters: parameters, headers: headers, body: body)
        if let urlRequest = urlRequest,
            let completion = completion {
            let task = session.dataTask(with: urlRequest, completionHandler: completion)
            task.resume()
        } else {
            completion?(nil, nil, RequestError.unableToBuildRequest)
        }
    }
    
    /// Partially replaces the current representations of the target resource with the uploaded content.
    ///
    /// - Parameters:
    ///   - url: HTTP address
    ///   - parameters: URL query items specified in [name : value] pairs
    ///   - headers: HTTP metadata
    ///   - body: data bytes transmitted in an HTTP transaction message
    ///   - completion: Data, URLResponse, Error
    func patch(url: String, parameters: [String : String]? = nil, headers: [String: String]? = nil, body: Data?, completion: RestManagerCompletion? = nil) {
        let urlRequest = URLRequest.init(url: url, method: .PATCH, parameters: parameters, headers: headers, body: body)
        if let urlRequest = urlRequest,
            let completion = completion {
            let task = session.dataTask(with: urlRequest, completionHandler: completion)
            task.resume()
        } else {
            completion?(nil, nil, RequestError.unableToBuildRequest)
        }
    }
    /// Removes all current representations of the target resource given by URL.
    ///
    /// - Parameters:
    ///   - url: HTTP address
    ///   - parameters: URL query items specified in [name : value] pairs
    ///   - headers: HTTP metadata
    ///   - body: data bytes transmitted in an HTTP transaction message
    ///   - completion: Data, URLResponse, Error
    func delete(url: String, parameters: [String : String]? = nil, headers: [String: String]? = nil, body: Data? = nil, completion: RestManagerCompletion? = nil) {
        let urlRequest = URLRequest(url: url, method: .DELETE, parameters: parameters, headers: headers, body: body)
        if let urlRequest = urlRequest,
            let completion = completion {
            let task = session.dataTask(with: urlRequest, completionHandler: completion)
            task.resume()
        } else {
            completion?(nil, nil, RequestError.unableToBuildRequest)
        }
    }
}

extension RestManager {
    private enum RequestError: Swift.Error, CustomStringConvertible {
        case unableToBuildRequest
        
        public var description: String {
            switch self {
            case .unableToBuildRequest:
                return "Unable to build request."
            }
        }
    }
}

