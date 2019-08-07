//
//  Alert.swift
//  Waffle-Clone
//
//  Created by Lubo on 6.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

struct Alert {
     static func showBasicAlert(with title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        return alert
    }
}
