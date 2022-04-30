//
//  SignUpView.swift
//  MyWeather
//
//  Created by amr on 28/04/2022.
//

import UIKit
import GoogleSignIn





class SignUpView: UIViewController {
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    let signInConfig = GIDConfiguration.init(clientID: "336168085547-cndln37htousqqtlq5q06lt9ls66hubn.apps.googleusercontent.com")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
                        guard let user = user else { return }
                        print("User: \(user.profile?.email ?? "NO email found")")
        }
    
//        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self, callback: nil)
//        GIDSignIn.sharedInstance.presentingViewController = self
//        GIDSignIn.sharedInstance
        signOutButton.isHidden = true
    }
    @IBAction func signIn(_ sender: Any) {
        
        
       
      
//        GIDSignIn.sharedInstance.signIn( with: signInConfig, presenting: self ) { user, error in
//            guard error == nil else { return }
//            guard let user = user else { return }
//            print("User: \(user.profile?.email ?? "NO email found")")
//
//            // Your user is signed in!
//        }
      
        
        
    }
    

    
    
        
        
        
        
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        
        GIDSignIn.sharedInstance.signOut()
    }
    
}
