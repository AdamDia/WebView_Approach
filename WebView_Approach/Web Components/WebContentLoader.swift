//
//  WebContentLoader.swift
//  WebView_Approach
//
//  Created by Adam Essam on 12/12/2023.
//

import UIKit
import WebKit

class WebContentLoader {
    private let webView: WKWebView
    private let webContentModifier: WebContentModifier
    
    init(webView: WKWebView, webContentModifier: WebContentModifier) {
        self.webView = webView
        self.webContentModifier = webContentModifier
    }
    
    func loadWebViewWithContent(_ htmlContent: String, originalPath: URL) {
        do {
            let modifiedHtmlContent = webContentModifier.modifyContent(htmlContent, imageName: "micky")
            let modifiedIndexPath = originalPath.deletingLastPathComponent().appendingPathComponent("modified_index.html")
            try modifiedHtmlContent.write(to: modifiedIndexPath, atomically: true, encoding: .utf8)
            
            DispatchQueue.main.async { [weak self] in
                self?.webView.loadFileURL(modifiedIndexPath, allowingReadAccessTo: modifiedIndexPath.deletingLastPathComponent())
            }
        } catch {
            print("Error loading HTML content: \(error)")
        }
    }
}
