//
//  SignInViewController.swift
//  Eventually
//
//  Created by Arthur Ford on 12/16/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit
import Firebase

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .label
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("signed out")
            //navigationController?.popToRootViewController(animated: true)
        } catch let signOutError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
