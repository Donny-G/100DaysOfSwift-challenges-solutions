//
//  DetailViewController.swift
//  Project16
//
//  Created by Donny G on 13/09/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var info: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        view = webView
        loadLink()
    }
    
    func loadLink() {
        guard let info = info, let url = URL(string: info) else {fatalError("Unable to load site")}
        webView.load(URLRequest(url: url))
    }

}
