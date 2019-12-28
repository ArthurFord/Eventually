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
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        do {
            try checkCredentials()
        } catch  {
            print(error)
        }
    }
    
    func checkCredentials() throws {
        let query: [String: Any] = [    kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrLabel as String: K.authLabel,
                                        kSecMatchLimit as String: kSecMatchLimitOne,
                                        kSecReturnAttributes as String: true,
                                        kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeychainError.unexpectedPasswordData
        }
        let credentials = Credentials(username: account, password: password)
        
        Auth.auth().signIn(withEmail: credentials.username, password: credentials.password) {authResult, error in
            if let err = error {
                print(err)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc = storyboard.instantiateViewController(identifier: K.VcId.masterVCID) as? MasterViewController {
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.navigationBar.prefersLargeTitles = true
                    vc.title = "Events"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
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


