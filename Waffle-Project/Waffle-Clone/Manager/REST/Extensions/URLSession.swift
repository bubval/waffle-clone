//
//  URLSession.swift
//  Waffle-Clone
//
//  Created by Lubo on 22.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation
import Dispatch

public typealias DataTaskResult = (data: Data?, response: URLResponse?, error: Error?)

extension URLSession {
    
    public func dataTask(request: URLRequest) -> DataTaskResult {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let dataTask = self.dataTask(with: request) { (requestData, requestResponse, requestError) in
            data = requestData
            response = requestResponse
            error = requestError
        }
        dataTask.resume()
        
        return (data, response, error)
    }
    
    public func dataTask(url: URL) -> DataTaskResult {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let dataTask = self.dataTask(with: url) { (urlData, urlResponse, urlError) in
            data = urlData
            response = urlResponse
            error = urlError
        }
        dataTask.resume()
        
        return (data, response, error)
    }
}

