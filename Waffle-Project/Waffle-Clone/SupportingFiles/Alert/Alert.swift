//
//  Alert.swift
//  Waffle-Clone
//
//  Created by Lubo on 6.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
     static func showBasicAlert(with title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        return alert
    }
}
