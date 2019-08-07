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
        // Initial root view controller is set to Launch Screen.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "LaunchViewController")
        self.window?.makeKeyAndVisible()
        
        // Root view controller is changed depending on authentication.
        authenticateUser()
    
        return true
    }
    
    /// If keychain contains a valid access token the user is sent to Repository View Controller. Otherwise, user is shown an error and sent to Login View Controller.
    private func authenticateUser() {
        authenticationManager.hasValidToken() { (success, errorDescription) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if success {
                // Changes root view controller to Repository View Controller.
                DispatchQueue.main.async {
                    self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "RepoViewController") as! RepositoryViewController
                    self.window?.makeKeyAndVisible()
                }
            } else {
                // Changes root view contoller to Login View Controller.
                DispatchQueue.main.async {
                    self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self.window?.makeKeyAndVisible()
                    // Displays alert describing why the user was unable to authenticate and sign in.
                    if let errorDescription = errorDescription {
                        let alert = Alert.showBasicAlert(with: "Error", message: errorDescription)
                        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    internal func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Accessed from UIApplication.
        // Checks if call is coming from Login View Controller by comparing the redirection url scheme and host (scheme://host).
        if url.scheme == AuthenticationConstants.callbackScheme {
            if url.host == AuthenticationConstants.callbackHost {
                // Consists of redirect URL (scheme://host) AND query items
                if let urlComponents = URLComponents(string: url.absoluteString),
                    // Query items consists of code (token identifying user) and state (protection against cross-site request forgery attacks)
                    let queryItems = urlComponents.queryItems,
                    // Specifies user identity
                    let code = queryItems[0].value{
                    authenticationManager.getAccessToken(code: code) { (response, error) in
                        if let response = response {
                            // Saves access token to keychain.
                            AuthenticationManager.accessToken = response.accessToken
                            // Checks validity of access token and transfers user to appropriate view controller.
                            self.authenticateUser()
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

