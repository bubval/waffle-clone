//
//  String.swift
//  Waffle-Clone
//
//  Created by Lubo on 22.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

public enum httpError: Swift.Error, CustomStringConvertible {
    case status(code: Int)
    case customError(message: String)
    
    public var description: String {
        switch self {
        case .status(let code):
            if code >= 400 && code < 600 {
                switch code {
                case 400:
                    return "Bad Request"
                case 401:
                    return "Unauthorized"
                case 403:
                    return "Forbidden"
                case 404:
                    return "Not Found"
                case 406:
                    return "Not Accessible"
                case 500:
                    return "Internal Server Error"
                case 501:
                    return "Not Implemented"
                case 502:
                    return "Bad Gateway"
                case 503:
                    return "Service Unavailable"
                default:
                    return "Undefined http error"
                }
            }
        case .customError(let message):
            return message
        }
        return "Not an http error"
    }
}
