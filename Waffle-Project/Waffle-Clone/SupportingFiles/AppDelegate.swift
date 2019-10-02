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
    let loginManager = LoginManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
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
                    getToken(code: code) { (success) in
                        if success {
                            DispatchQueue.main.async {
                                let rootViewController = self.window!.rootViewController as! UINavigationController
                                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = mainStoryboard.instantiateViewController(withIdentifier: "RepoViewController") as! RepositoryViewController
                                rootViewController.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
        return true
    }
    
    private func getToken(code: String, completion: @escaping(Bool) -> ()) {
        authenticationManager.getAccessToken(code: code) { (response, error) in
            if let response = response {
                // Saves access token to keychain.
                print(response.accessToken)
                AuthenticationManager.accessToken = response.accessToken
                completion(true)
            } else {
                completion(false)
            }
        }
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
