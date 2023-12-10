//
//  ViewController.swift
//  WebView_Approach
//
//  Created by Adam Essam on 03/12/2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    // Handles post-load modifications to the web content
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
}
