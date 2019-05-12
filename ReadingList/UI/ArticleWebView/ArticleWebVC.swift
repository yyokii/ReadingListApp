//
//  ArticleWebVC.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/29.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import WebKit

class ArticleWebVC: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var urlString: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: urlString!)!
        webView.load(URLRequest(url: url))
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    
}
