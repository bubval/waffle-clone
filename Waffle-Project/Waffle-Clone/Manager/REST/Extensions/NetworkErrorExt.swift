//
//  NetworkErrorExt.swift
//  Waffle-Clone
//
//  Created by Lubo on 26.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

extension NetworkError {
    
    init?(for urlRequest: URLRequest?) {
        if urlRequest == nil {
            self = NetworkError.unableToBuildRequest
        } else {
            return nil
        }
    }
}
