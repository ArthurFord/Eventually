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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func SignInButtonTapped(_ sender: UIButton) {
        
        guard var email = emailTextField.text else {return}
        guard var password = passwordTextField.text else {return}
        
        email = "1@2.com"
        password = "qwerty"
        
        
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
}



