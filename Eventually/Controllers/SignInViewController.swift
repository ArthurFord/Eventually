//
//  SignInViewController.swift
//  Eventually
//
//  Created by Arthur Ford on 12/16/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var credentials: Credentials?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        if credentials != nil {
            emailTextField.text = credentials?.username
            passwordTextField.text = credentials?.password
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func SignInButtonTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        do {
            try addCredentials(account: email, password: password)
        } catch  {
            print(error)
        }
        
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
    
    func addCredentials(account: String, password: String) throws {
        let credentials = Credentials(username: account, password: password)
        let passwordFinal = credentials.password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [    kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrAccount as String: credentials.username,
                                        kSecAttrLabel as String: K.authLabel,
                                        kSecValueData as String: passwordFinal]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
}




