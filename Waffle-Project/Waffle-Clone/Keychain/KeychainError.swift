//
//  SecureStoreError.swift
//  Waffle-Clone
//
//  Created by Lubo on 2.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

public enum KeychainError: Error {
    case stringToDataConversionError
    case dataToStringConversionError
    case unhandledError(message: String)
}

extension KeychainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .stringToDataConversionError:
            return NSLocalizedString("String to Data conversion error", comment: "")
        case .dataToStringConversionError:
            return NSLocalizedString("Data to String conversion error", comment: "")
        case .unhandledError(let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}
