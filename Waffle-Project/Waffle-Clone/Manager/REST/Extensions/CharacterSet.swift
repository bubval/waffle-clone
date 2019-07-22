//
//  CharacterSet.swift
//  Waffle-Clone
//
//  Created by Lubo on 22.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

extension CharacterSet {
    
    static func URLQueryAllowedCharacterSet() -> CharacterSet {
        let delimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: delimitersToEncode + subDelimitersToEncode)
        return allowedCharacterSet
    }
}
