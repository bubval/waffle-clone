//
//  GithubManager.swift
//  Waffle-Clone
//
//  Created by Lubo on 29.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

class GithubManager: RestManager {
    
    private let baseUrl = "https://api.github.com"
    private var authentication: Authentication?

    public override init(session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        super.init(session: session)
        // Sets access token if present in keychain.
        if let accessToken = AuthenticationManager.accessToken {
            self.authentication = Authentication(accessToken: accessToken)
        } else {
            self.authentication = nil
        }
    }
    
    /// Used to retrieve information from GitHub. Using GET only retrieves data and has no effect on the data.
    ///
    /// - Parameters:
    ///   - url: HTTP address
    ///   - parameters: URL query items specified in [name : value] pairs
    ///   - headers: HTTP metadata
    ///   - completion: Decodable object or Error
    func get<T:Decodable>(path: String, parameters: [String : String]? = nil, headers: [String: String]? = nil, completion: @escaping (T?, Error?) -> Swift.Void) {
        let (newHeaders, newParameters) = generateQuery(headers, parameters)
        
        self.get(url: self.baseUrl + path, parameters: newParameters, headers: newHeaders) { (data, response, error) in
            guard error == nil else {
                return completion(nil, UnknownError.internalError(error: error!))
            }
            if let response = response as? HTTPURLResponse {
                guard response.statusCode >= 200 && response.statusCode <= 299 else {
                    return completion(nil, NetworkError.status(code: response.statusCode))
                }
            }
            
            if let data = data {
                do {
                    let model = try GithubManager.decoder.decode(T.self, from: data)
                    completion(model, nil)
                } catch {
                    completion(nil, JsonError.unparsableModel)
                }
            }
        }
    }
    
    /// Used to send data to GitHub.
    ///
    /// - Parameters:
    ///   - url: HTTP address
    ///   - parameters: URL query items specified in [name : value] pairs
    ///   - headers: HTTP metadata
    ///   - body: data bytes transmitted in an HTTP transaction message
    ///   - completion: Decodable object or Error
    func post<T:Decodable>(path: String, parameters: [String : String]? = nil, headers: [String: String]? = nil, body: Data?, completion: @escaping (T?, Error?) -> Swift.Void) {
        let (newHeaders, newParameters) = generateQuery(headers, parameters)

        self.post(url: self.baseUrl + path, parameters: newParameters, headers: newHeaders, body: body) { (data, response, error) in
            
            guard error == nil else {
                return completion(nil, UnknownError.internalError(error: error!))
            }
            if let response = response as? HTTPURLResponse {
                guard response.statusCode >= 200 && response.statusCode <= 299 else {
                    return completion(nil, NetworkError.status(code: response.statusCode))
                }
            }
            
            if let data = data {
                do {
                    let model = try GithubManager.decoder.decode(T.self, from: data)
                    completion(model, nil)
                } catch {
                    completion(nil, JsonError.unparsableModel)
                }
            }
        }
    }
    
    /// Replaces all the current representations of the target resource with the uploaded content.
    ///
    /// - Parameters:
    ///   - url: HTTP address
    ///   - parameters: URL query items specified in [name : value] pairs
    ///   - headers: HTTP metadata
    ///   - body: data bytes transmitted in an HTTP transaction message
    ///   - completion: Decodable object or Error
    func put<T:Decodable>(path: String, parameters: [String : String]? = nil, headers: [String: String]? = nil, body: Data?, completion: @escaping (T?, Error?) -> Swift.Void) {
        let (newHeaders, newParameters) = generateQuery(headers, parameters)

        self.put(url: self.baseUrl + path, parameters: newParameters, headers: newHeaders, body: body) { (data, response, error) in
            
            guard error == nil else {
                return completion(nil, UnknownError.internalError(error: error!))
            }
            if let response = response as? HTTPURLResponse {
                guard response.statusCode >= 200 && response.statusCode <= 299 else {
                    return completion(nil, NetworkError.status(code: response.statusCode))
                }
            }
            
            if let data = data {
                do {
                    let model = try GithubManager.decoder.decode(T.self, from: data)
                    completion(model, nil)
                } catch {
                    completion(nil, JsonError.unparsableModel)
                }
            }
        }
    }
    
    /// Removes all current representations of the target resource given by URL.
    ///
    /// - Parameters:
    ///   - path: HTTP address
    ///   - parameters: URL query items specified in [name : value] pairs
    ///   - headers: HTTP metadata
    ///   - body: data bytes transmitted in an HTTP transaction message
    ///   - completion: Decodable object or Error
    func delete<T:Decodable>(path: String, parameters: [String : String]? = nil, headers: [String: String]? = nil, body: Data?, completion: @escaping (T?, Error?) -> Swift.Void) {
        let (newHeaders, newParameters) = generateQuery(headers, parameters)

        self.delete(url: self.baseUrl + path, parameters: newParameters, headers: newHeaders) { (data, response, error) in
            
            guard error == nil else {
                return completion(nil, UnknownError.internalError(error: error!))
            }
            if let response = response as? HTTPURLResponse {
                guard response.statusCode >= 200 && response.statusCode <= 299 else {
                    return completion(nil, NetworkError.status(code: response.statusCode))
                }
            }
            
            if let data = data {
                do {
                    let model = try GithubManager.decoder.decode(T.self, from: data)
                    completion(model, nil)
                } catch {
                    completion(nil, JsonError.unparsableModel)
                }
            }
        }
    }
}

// MARK: - Codable

extension GithubManager {
    
    private static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: Locale.current.identifier)
            let currentTimeZone = TimeZone.current
            formatter.timeZone = TimeZone(secondsFromGMT: currentTimeZone.secondsFromGMT())
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            throw DecodingError.typeMismatch(Date.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not decode date"))
        })
        return decoder
    }
    
    private static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let currentTimeZone = TimeZone.current
        formatter.timeZone = TimeZone(secondsFromGMT: currentTimeZone.secondsFromGMT())
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        encoder.dateEncodingStrategy = .formatted(formatter)
        return encoder
    }
}

// MARK: - Authentication

extension GithubManager {
    
    /// Takes headers and parameters passed by the user. If authentication is present, adds authentication to parameters. Adds encoding and content-type to headers.
    ///
    /// - Parameters:
    ///   - headers: Headers passed by the user.
    ///   - parameters: Parameters passed by the user.
    /// - Returns: New headers and parameters consisting of the ones passed by the user, authentication, content-type and encoding.
    private func generateQuery(_ headers: [String : String]?, _ parameters: [String : String]?) -> (headers: [String : String]?, parameters: [String : String]?) {
        var queryParamters: [String : String] = [:]
        var queryHeaders = [
            "Accept" : "application/vnd.github.v3+json",
            "Accept-Encoding" : "gzip",
            "Content-Type" : "application/json; charset=utf-8"
        ]
        if let authentication = authentication {
            queryParamters.updateValue(authentication.getValue(), forKey: authentication.getKey())
        }
        
        if let parameters = parameters {
            queryParamters.merge(dict: parameters)
        }
        if let headers = headers {
            queryHeaders.merge(dict: headers)
        }
        return (queryHeaders, queryParamters)
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

// MARK: - Error Handing

extension GithubManager {
    enum UnknownError: Swift.Error, CustomStringConvertible {
        case internalError(error: Error)
        
        public var description: String {
            switch self {
            case .internalError(let error):
                return error.localizedDescription
            }
        }
    }
    
    enum JsonError: Swift.Error, CustomStringConvertible {
        case unparsableModel
        
        public var description: String {
            switch self {
            case .unparsableModel:
                return "Unable to parse JSON response to model."
            }
        }
    }
    
    enum NetworkError: Swift.Error, CustomStringConvertible {
        case status(code: Int)
        
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
                return "Not an client or server error"
            }
        }
    }
}
