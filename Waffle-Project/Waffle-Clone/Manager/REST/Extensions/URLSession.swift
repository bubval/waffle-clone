//
//  URLSession.swift
//  Waffle-Clone
//
//  Created by Lubo on 22.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation
import Dispatch

public typealias SynchronousDataTaskResult = (data: Data?, response: URLResponse?, error: Error?)

extension URLSession {
    
    public func synchronousDataTask(request: URLRequest) -> SynchronousDataTaskResult {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: request) { (requestData, requestResponse, requestError) in
            data = requestData
            response = requestResponse
            error = requestError
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
    
    public func synchronousDataTask(url: URL) -> SynchronousDataTaskResult {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.dataTask(with: url) { (urlData, urlResponse, urlError) in
            data = urlData
            response = urlResponse
            error = urlError
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
}

