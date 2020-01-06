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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ThemeManager.currentTheme().statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
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
            moveToEvents(credentials: credentials!)
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
    
    func moveToEvents(credentials: Credentials) {
        let email = credentials.username
        let password = credentials.password
        
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            if let err = error {
                let alert = UIAlertController(title: "Login Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
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


