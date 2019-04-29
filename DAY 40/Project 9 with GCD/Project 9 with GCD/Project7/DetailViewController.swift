//
//  DetailViewController.swift
//  Project7
//
//  Created by Donny G on 01/04/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webview: WKWebView!
    var detailView: Petition?
    
    override func loadView() {
        webview = WKWebView()
        view = webview
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let detailView = detailView else {return}
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        <body style="background-color:black;">
        <p style="color:white;">\(detailView.body)</p>
        </body>
        </html>
        """
        webview.loadHTMLString(html, baseURL: nil)
}
    
}
