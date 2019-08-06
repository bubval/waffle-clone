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
    case savingError
    case gettingError
}

extension KeychainError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .stringToDataConversionError:
            return "String to Data conversion error"
        case .dataToStringConversionError:
            return "Data to String conversion error"
        case .unhandledError(let message):
            return message
        case .savingError:
            return "Saving generic password failed."
        case .gettingError:
            return "Retriving generic password failed."
        }
    }
}
