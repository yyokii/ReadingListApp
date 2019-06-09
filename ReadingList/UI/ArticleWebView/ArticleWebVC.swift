//
//  ArticleWebVC.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/29.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Hero
import UIKit
import WebKit

class ArticleWebVC: UIViewController {
    var webView: WKWebView!
    var urlString: String?
 
    class func articleWebVCInit(urlSrting: String) -> UIViewController {
        let vc = UIStoryboard(name: "Article", bundle: nil).instantiateInitialViewController() as! ArticleWebVC
        vc.urlString = urlSrting
        let nav = UINavigationController(rootViewController: vc)
        nav.hero.isEnabled = true
        return nav
    }
    
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
        let close = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.close))
        
        toolbarItems = [close ,refresh]
        navigationController?.isToolbarHidden = false
    }
    
    @objc private func close() {
        hero.dismissViewController()
    }
}

extension ArticleWebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}

extension ArticleWebVC: HeroViewControllerDelegate {
    func heroWillStartAnimatingFrom(viewController: UIViewController) {
        hero.modalAnimationType = .fade
    }
}
