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
    
    
    var credentials: Credentials?
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var eventuallyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        signInButton.tintColor = ThemeManager.currentTheme().topTextColor
        signInButton.setTitleColor(ThemeManager.currentTheme().topTextColor, for: .normal)
        signUpButton.tintColor = ThemeManager.currentTheme().topTextColor
        signUpButton.setTitleColor(ThemeManager.currentTheme().topTextColor, for: .normal)
        eventuallyLabel.textColor = ThemeManager.currentTheme().topTextColor
        
        do {
            try checkCredentials()
        } catch  {
            print(error)
        }
        
        if credentials != nil {
            moveToSignInScreen()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        moveToSignInScreen()
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
        credentials = Credentials(username: account, password: password)
    }
    
    func moveToSignInScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         if let vc = storyboard.instantiateViewController(identifier: K.VcId.signInViewControllerID) as? SignInViewController {
             vc.modalPresentationStyle = .fullScreen
            if credentials != nil {
                vc.credentials = credentials
            }
             self.navigationController?.pushViewController(vc, animated: true)
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


