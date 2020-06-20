//
//  ArticleWebVC.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/29.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import WebKit

class ArticleWebVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var toolbarView: WebToolBarView!

    @IBOutlet var toolBarBottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var toolBarHeight: NSLayoutConstraint!
    
    private var presenter: ArticleWebPresenterInput!
    
    /// ナビゲーション付きのwebviewを作成する
    class func viewController (item: ReadingItem) -> UIViewController {
        let vc = UIStoryboard(name: "Article", bundle: nil).instantiateInitialViewController() as! ArticleWebVC
        let model = ArticleWebModel()
        let presenter = ArticleWebPresenter.init(view: vc, model: model)
        presenter.item = item
        vc.inject(presenter: presenter)
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.barTintColor = UIColor.white
        return nav
    }
    
    func inject(presenter: ArticleWebPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWebView()
        presenter.viewDidLoad()
    }
    
    private func configureWebView() {
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.uiDelegate = self
        toolbarView.delegate = self
    }
}

extension ArticleWebVC: ArticleWebPresenterOutput {
    
    func hideToolBar() {
        toolbarView.isHidden = true
    }
    
    func showToolBar() {
        toolbarView.isHidden = false
    }
    
    func showAddReadinListBtn() {
        toolbarView.configureToReadingListBtn()
    }
    
    func showAddFinishedListBtn() {
        toolbarView.configureToFinishedListBtn()
    }
    
    func showSuccessAddReadingListDialog() {
        SwiftMessageUtil.showIconTextMessage(type: .ToReadingList, iconText: "👍", title: "", message: "リーディングリストに追加しました")
    }
    
    func showSuccessAddFinishedListDialog() {
        SwiftMessageUtil.showIconTextMessage(type: .ToFinishedList, iconText: "🌟", title: "", message: "読み終わり記事に追加しました")
    }
    
    func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    func load(url: URL) {
        title = "読み込み中・・・"
        webView.load(URLRequest(url: url))
    }
}

extension ArticleWebVC: WebToolBarDelegate {
    func closeBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func goBackBtnTapped() {
        webView.goBack()
    }
    
    func goForwardBtnTapped() {
        webView.goForward()
    }

    func actionBtnTapped() {
        presenter.tapItemActionButton()
    }
}

extension ArticleWebVC: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y > 0) {
            // 下にスクロール（ヘッダーフッターを隠す）
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                
                // self.navigationController?.setNavigationBarHidden(true, animated: true)

                self.toolbarView.frame = CGRect(x: 0, y: self.webView.frame.maxY, width: self.toolbarView.frame.width, height: self.toolbarView.frame.height)
                
            }, completion: nil)
            
        } else if(velocity.y < 0) {
            // 上にスクロール（ヘッダーフッターを表示する）
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                // self.navigationController?.setNavigationBarHidden(false, animated: true)
                
                self.toolbarView.frame = CGRect(x: 0, y: self.webView.frame.maxY - self.toolbarView.frame.height, width: self.toolbarView.frame.width, height: self.toolbarView.frame.height)
                
            }, completion: nil)
        }
    }
}

extension ArticleWebVC: WKUIDelegate {
    
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame?.isMainFrame != true {
            webView.load(navigationAction.request)
        }
        
        return nil
    }
}

extension ArticleWebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if let navTitle = webView.title, !navTitle.isEmpty {
            title = navTitle
        } else {
            title = "YOMU"
        }
    }
}
