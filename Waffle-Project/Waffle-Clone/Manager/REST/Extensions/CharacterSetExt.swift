//
//  CharacterSet.swift
//  Waffle-Clone
//
//  Created by Lubo on 22.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

extension CharacterSet {
    
    /// Removes delimiters from specified Charset. A delimiter is a character used to separate boundaries of independent regions
    ///
    /// - Parameters:
    ///   - delimiters: delimiters on the top level of formatting
    ///   - subdelimiters: delimiters on sub-levels of formatting
    /// - Returns: CharacterSet without encoding delimiters
    static func URLQueryAllowedCharacterSet(delimiters: String = ":#[]@", subdelimiters: String = "!$&'()*+,;=") -> CharacterSet {
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: delimiters + subdelimiters)
        return allowedCharacterSet
    }
}
