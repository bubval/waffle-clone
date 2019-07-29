//
//  GithubManager.swift
//  Waffle-Clone
//
//  Created by Lubo on 29.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

public class GithubManager: RestManager {
    
    private let baseUrl = "https://api.github.com"
    private var defaultHeaders = [
        "Accept" : "application/vnd.github.v3+json",
        RequestHeaderFields.acceptEncoding.rawValue : "gzip",
        "Content-Type" : "application/json; charset=utf-8"
    ]
    
    public override init(session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        super.init(session: session)
    }
        
    /// Used to retrieve information from GitHub. Using GET only retrieves data and has no effect on the data.
    ///
    /// - Parameters:
    ///   - url: HTTP address
    ///   - parameters: URL query items specified in [name : value] pairs
    ///   - headers: HTTP metadata
    ///   - completion: Decodable object or Error
    public func githubGet<T:Decodable>(path: String, parameters: [String : String]? = nil, headers: [String: String]? = nil, completion: @escaping (T?, Error?) -> Swift.Void) {
        self.get(url: self.baseUrl + path, parameters: parameters, headers: headers ?? defaultHeaders) { (data, _, error) in
            if let data = data {
                do {
                    let model = try GithubManager.decoder.decode(T.self, from: data)
                    completion(model, error)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
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
    public func githubPost<T:Decodable>(path: String, parameters: [String : String]? = nil, headers: [String: String]? = nil, body: Data?, completion: @escaping (T?, Error?) -> Swift.Void) {
        self.post(url: self.baseUrl + path, parameters: parameters, headers: headers ?? defaultHeaders, body: body) { (data, _, error) in
            if let data = data {
                do {
                    let model = try GithubManager.decoder.decode(T.self, from: data)
                    completion(model, error)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
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
    public func githubPut<T:Decodable>(path: String, parameters: [String : String]? = nil, headers: [String: String]? = nil, body: Data?, completion: @escaping (T?, Error?) -> Swift.Void) {
        self.put(url: self.baseUrl + path, parameters: parameters, headers: headers ?? defaultHeaders, body: body) { (data, _, error) in
            if let data = data {
                do {
                    let model = try GithubManager.decoder.decode(T.self, from: data)
                    completion(model, error)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
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
    public func githubDelete<T:Decodable>(path: String, parameters: [String : String]? = nil, headers: [String: String]? = nil, body: Data?, completion: @escaping (T?, Error?) -> Swift.Void) {
        self.delete(url: self.baseUrl + path, parameters: parameters, headers: headers ?? defaultHeaders) { (data, _, error) in
            if let data = data {
                do {
                    let model = try GithubManager.decoder.decode(T.self, from: data)
                    completion(model, error)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
}

// MARK: - Codable

extension GithubManager {
    
    public static var decoder: JSONDecoder {
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
    
    public static var encoder: JSONEncoder {
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
