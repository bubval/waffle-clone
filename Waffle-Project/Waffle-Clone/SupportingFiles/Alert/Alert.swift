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
    private static func showBasicAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let topController = UIApplication.topViewController() {
            topController.present(alert, animated: true)
        }
    }
    
    static func KeychainSavingAlert() {
        showBasicAlert(with: "Keychain Error", message: "Saving generic password failed.")
    }
    
    static func KeychainRetrivingAlert() {
        showBasicAlert(with: "Keychain Error", message: "Retrieving generic password failed.")
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
