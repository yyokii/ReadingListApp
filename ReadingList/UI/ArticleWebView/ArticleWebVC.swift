//
//  ArticleWebVC.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/29.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import WebKit

/// webViewで表示するアイテム
struct WebItem {
    var url: String
    var title: String
    var imageUrl: String?
}

class ArticleWebVC: UIViewController {
    @IBOutlet weak var baseView: UIView!
 
    var webView: WKWebView!
    var item: WebItem!
    var model: ArticleWebModelInput!
 
    /// ナビゲーション付きのwebviewを作成する
    class func articleWebVCInit(webItem: WebItem, model: ArticleWebModelInput = ArticleWebModel()) -> UIViewController {
        let vc = UIStoryboard(name: "Article", bundle: nil).instantiateInitialViewController() as! ArticleWebVC
        vc.item = webItem
        vc.model = model
        let nav = UINavigationController(rootViewController: vc)
        // nav.hero.isEnabled = true
        return nav
    }
    
    // Todo: 呼ぶべきじゃない?
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: item.url)!
        webView.load(URLRequest(url: url))
        title = "読み込み中・・・"
        
        configureToolbar()
        
        
        if UserDefaultManager.shareInstance.isFirstOpenArticleWebView() {
            SwiftMessageUtil.showWebHowtoView()
            UserDefaultManager.shareInstance.setFirstOpenArticleWebView()
        }
    }
    
    // https://stackoverflow.com/questions/43073738/change-size-of-uibarbuttonitem-image-in-swift-3
    private func configureToolbar() {
        // 閉じるボタン
        let closeBtnView = UIButton(frame: CGRect(x:0, y:0, width:25, height:25))
        closeBtnView.setBackgroundImage(UIImage(named: "cross"), for: .normal)
        closeBtnView.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        let closeBtn = UIBarButtonItem(customView: closeBtnView)
        closeBtn.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        closeBtn.customView?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // リーディングリストに追加ボタン
        let readingBtnView = UIButton(frame: CGRect(x:0, y:0, width:25, height:25))
        readingBtnView.setBackgroundImage(UIImage(named: "reading"), for: .normal)
        readingBtnView.addTarget(self, action: #selector(self.addToReadingList), for: .touchUpInside)
        let readingBtn = UIBarButtonItem(customView: readingBtnView)
        readingBtn.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        readingBtn.customView?.heightAnchor.constraint(equalToConstant: 25).isActive = true

        // 既読リストに追加ボタン
        let finishedReadingBtnView = UIButton(frame: CGRect(x:0, y:0, width:25, height:25))
        finishedReadingBtnView.setBackgroundImage(UIImage(named: "reading_finished"), for: .normal)
        finishedReadingBtnView.addTarget(self, action: #selector(self.addToFinishedReadingList), for: .touchUpInside)
        let finishedReadingBtn = UIBarButtonItem(customView: finishedReadingBtnView)
        finishedReadingBtn.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        finishedReadingBtn.customView?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // 戻るボタン
        let goBackBtnView = UIButton(frame: CGRect(x:0, y:0, width:25, height:25))
        goBackBtnView.setBackgroundImage(UIImage(named: "arrow_left"), for: .normal)
        goBackBtnView.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        let goBackBtn = UIBarButtonItem(customView: goBackBtnView)
        goBackBtn.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        goBackBtn.customView?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // 進むボタン
        let goForwardBtnView = UIButton(frame: CGRect(x:0, y:0, width:24, height:24))
        goForwardBtnView.setBackgroundImage(UIImage(named: "arrow_right"), for: .normal)
        goForwardBtnView.addTarget(self, action: #selector(self.goForward), for: .touchUpInside)
        let goForwardBtn = UIBarButtonItem(customView: goForwardBtnView)
        goForwardBtn.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        goForwardBtn.customView?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // スペーサー
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let fixedItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedItem.width = 30
        
        // ツールバーに追加する
        toolbarItems = [closeBtn, flexibleItem, goBackBtn, fixedItem, goForwardBtn, fixedItem, readingBtn, fixedItem, finishedReadingBtn]
        navigationController?.isToolbarHidden = false
    }
    
    @objc private func close() {
        // hero.dismissViewController()
    }
    
    @objc private func goBack() {
        webView.goBack()
    }
    
    @objc private func goForward() {
        webView.goForward()
    }
    
    @objc private func addToReadingList() {
        model.addItemToReadingList(from: item)
        SwiftMessageUtil.showIconTextMessage(type: .ToReadingList, iconText: "👍", title: "保存しました", message: "リーディングリストに記事を追加しました")
    }
    
    @objc private func addToFinishedReadingList() {
        model.addItemToFinishedList(from: item)
        SwiftMessageUtil.showIconTextMessage(type: .ToFinishedList, iconText: "👍", title: "保存しました", message: "読み終わりリストに記事を追加しました")
    }
}

extension ArticleWebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}
