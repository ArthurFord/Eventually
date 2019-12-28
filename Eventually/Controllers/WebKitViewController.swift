//
//  WebKitViewController.swift
//  Eventually
//
//  Created by Arthur Ford on 12/28/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var webKitView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webKitView.uiDelegate = self
       
        let privacyURL = URL(string: "https://eventually-app.s3.amazonaws.com/Eventually_App_privacy_policy.html")
        
        let privacyRequest = URLRequest(url: privacyURL!)
        
        webKitView.load(privacyRequest)
        
    }

}
