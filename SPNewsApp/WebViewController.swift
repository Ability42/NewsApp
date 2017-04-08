//
//  WebViewController.swift
//  SPNewsApp
//
//  Created by Stepan Paholyk on 4/8/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var urlToLoad: String?
    
    override func loadView() {
        super.loadView()
        
        self.setupWebView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstrains()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavItem()
        let myRequest = URLRequest(url: URL(string: urlToLoad!)!)
        webView.load(myRequest)
        
    }
    
    func setupWebView() {
        
        let webViewConfig = WKWebViewConfiguration()
        let webViewRect = CGRect(x: 0, y: 0, width: Int(view.bounds.width), height: Int(view.bounds.height))
        
        webView = WKWebView(frame: webViewRect, configuration: webViewConfig)
        webView.uiDelegate = self
        view.addSubview(webView)
    }
    
    func setupConstrains() {
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let views = ["view": view as Any, "webView": webView as Any]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", options: .alignAllLeading, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|", options: .alignAllTop, metrics: nil, views: views)
        
        view.addConstraints(horizontalConstraints)
        view.addConstraints(verticalConstraints)
    }
    
    func setupNavItem() {
        self.navigationItem.title = "Origin"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "closeWebVC" {
            self.webView.stopLoading()
            self.webView.uiDelegate = nil
            self.webView.removeFromSuperview()
        }
    }
    
}
