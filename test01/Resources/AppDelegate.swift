//
//  AppDelegate.swift
//  test01
//
//  Created by KimJongHee on 2022/05/17.
//

import UIKit
import Firebase
import FirebaseCore
import FBSDKCoreKit
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            // error 가 없다면 그리고 error 가 있다면
            if let error = error {
                // error 가 있다면
                print("Failed to sign in with Google : \(error)")
            }
            return
        }
        
        guard let user = user else {
            // user 에 user 가 있다면 else user 에 user 가 없다면 
            return
        }
        
        guard let email = user.profile.email, let firstName = user.profile.givenName, let lastName = user.profile.familyName else {
            print("no Find")
            return
        }
        
        DatabaseManager.shared.userExists(with: email, completion: { exists in
            if !exists {
                // 같은 이메일이 없으면
                // 데이터가 들어간다
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAdress: email))
            }
        })
        
        guard let authentication = user.authentication else {
            print("Missing auth object off of google user")
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
            guard authResult != nil, error == nil else {
                print("failed to log in with google credential")
                return
            }
            print("Successfully signed in with Goolge credential")
            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google user was disconnected")
    }
    
}


