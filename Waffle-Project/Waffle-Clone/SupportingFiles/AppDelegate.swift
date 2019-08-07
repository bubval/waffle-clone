//
//  AppDelegate.swift
//  Waffle-Clone
//
//  Created by Lubo on 18.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let authenticationManager = AuthenticationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "LaunchViewController")
        self.window?.makeKeyAndVisible()
        
        authenticateUser()
    
        return true
    }
    
    private func authenticateUser() {
        authenticationManager.hasValidToken() { (success, errorDescription) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if success {
                DispatchQueue.main.async {
                    self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "RepoViewController") as! RepositoryViewController
                    self.window?.makeKeyAndVisible()
                }
            } else {
                DispatchQueue.main.async {
                    self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self.window?.makeKeyAndVisible()
                    if let errorDescription = errorDescription {
                        let alert = Alert.showBasicAlert(with: "Error", message: errorDescription)
                        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    internal func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Redirect URL (scheme://host)
        if url.scheme == "waffleclone" {
            if url.host == "gitlogin" {
                // Redirect URL + with query items
                if let urlComponents = URLComponents(string: url.absoluteString),
                    // query items:
                    // 1. code - identifying user
                    // 2. state - used to protect against cross-site request forgery attacks)
                    let queryItems = urlComponents.queryItems {
                    let code = queryItems[0].value
                    
                    if let code = code {
                        authenticationManager.getAccessToken(clientID: AuthenticationConstants.clientId,
                                               clientSecret: AuthenticationConstants.clientSecret,
                                               code: code,
                                               redirectURL: AuthenticationConstants.redirectUrl) { (response, error) in
                                                
                                                if let response = response {
                                                    AuthenticationManager.accessToken = response.accessToken
                                                    self.authenticateUser()
                                                }
                        }
                    }
                }
            }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

