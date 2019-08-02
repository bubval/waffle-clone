//
//  SecureStore.swift
//  Waffle-Clone
//
//  Created by Lubo on 2.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation
import Security

public struct SecureStore {
    let secureStoreQueryable: SecureStoreQueryable
    
    public init(secureStoreQueryable: SecureStoreQueryable) {
        self.secureStoreQueryable = secureStoreQueryable
    }
    
    public func setValue(_ value: String, for userAccount: String) throws {
        // Check if it can encode the value to store into a Data type
        guard let encodedPassword = value.data(using: .utf8) else {
            throw SecureStoreError.string2DataConversionError
        }
        
        // Ask for the query to execute and append
        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = userAccount
        
        // Return the keychain item that matches the query
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
            // If the query succeeds, it means a password for that account already exists
        // If it exists - replace the existing password’s value using SecItemUpdate(_:_:)
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = encodedPassword
            
            status = SecItemUpdate(query as CFDictionary,
                                   attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                throw error(from: status)
            }
        // If it cannot find an item, add the item
        case errSecItemNotFound:
            query[String(kSecValueData)] = encodedPassword
            
            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw error(from: status)
            }
        default:
            throw error(from: status)
        }
    }
    
    public func getValue(for userAccount: String) throws -> String? {
        // Ask secureStoreQueryable for the query to execute
        var query = secureStoreQueryable.query
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = userAccount
        
        // Use SecItemCopyMatching(_:_:) to perform the search
        // On completion, queryResult will contain a reference to the found item, if available
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }
        
        switch status {
            // It found an item
        // Extract the data and then decode it into a Data type
        case errSecSuccess:
            guard
                let queriedItem = queryResult as? [String: Any],
                let passwordData = queriedItem[String(kSecValueData)] as? Data,
                let password = String(data: passwordData, encoding: .utf8)
                else {
                    throw SecureStoreError.data2StringConversionError
            }
            return password
        // If item not found return nil
        case errSecItemNotFound:
            return nil
        default:
            throw error(from: status)
        }
        
        return nil
    }
    
    public func removeValue(for userAccount: String) throws {
        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = userAccount
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }
    
    public func removeAllValues() throws {
        let query = secureStoreQueryable.query
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }
    
    private func error(from status: OSStatus) -> SecureStoreError {
        let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        return SecureStoreError.unhandledError(message: message)
    }
}
