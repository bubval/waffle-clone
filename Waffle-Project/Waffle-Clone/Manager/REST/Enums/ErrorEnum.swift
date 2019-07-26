//
//  String.swift
//  Waffle-Clone
//
//  Created by Lubo on 22.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

public enum networkError: Swift.Error, CustomStringConvertible {
    case status(code: Int)
    case unableToBuildRequest
    
    public var description: String {
        switch self {
        case .status(let code):
            if code >= 400 && code < 600 {
                switch code {
                case 400:
                    return "\(code) Bad Request"
                case 401:
                    return "\(code) Unauthorized"
                case 403:
                    return "\(code) Forbidden"
                case 404:
                    return "\(code) Not Found"
                case 406:
                    return "\(code) Not Accessible"
                case 500:
                    return "\(code) Internal Server Error"
                case 501:
                    return "\(code) Not Implemented"
                case 502:
                    return "\(code) Bad Gateway"
                case 503:
                    return "\(code) Service Unavailable"
                default:
                    return "\(code) Undefined HTTP error"
                }
            }
        case .unableToBuildRequest:
            return "Unable to build request."
        }
        return "Not an client or server error"
    }
}

public enum customError: Swift.Error, CustomStringConvertible {
    case localizedDescription(error: Error)
    
    public var description: String {
        switch self {
        case .localizedDescription(let error):
            return error.localizedDescription
        }
    }
}
