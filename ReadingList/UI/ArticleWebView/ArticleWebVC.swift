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
    
    // FIXME: 呼ぶべきじゃない?
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
    }
    
    // https://stackoverflow.com/questions/43073738/change-size-of-uibarbuttonitem-image-in-swift-3
    private func configureToolbar() {
        // 閉じるボタン
        let closeBtnView = UIButton(frame: CGRect(x:0, y:0, width:24, height:124))
        closeBtnView.setBackgroundImage(UIImage(named: "cross"), for: .normal)
        closeBtnView.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        let closeBtn = UIBarButtonItem(customView: closeBtnView)
        closeBtn.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        closeBtn.customView?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // リーディングリストに追加ボタン
        let readingBtnView = UIButton(frame: CGRect(x:0, y:0, width:24, height:24))
        readingBtnView.setBackgroundImage(UIImage(named: "reading"), for: .normal)
        readingBtnView.addTarget(self, action: #selector(self.addToReadingList), for: .touchUpInside)
        let readingBtn = UIBarButtonItem(customView: readingBtnView)
        readingBtn.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        readingBtn.customView?.heightAnchor.constraint(equalToConstant: 25).isActive = true

        // 既読リストに追加ボタン
        let finishedReadingBtnView = UIButton(frame: CGRect(x:0, y:0, width:24, height:24))
        finishedReadingBtnView.setBackgroundImage(UIImage(named: "reading_finished"), for: .normal)
        finishedReadingBtnView.addTarget(self, action: #selector(self.addToFinishedReadingList), for: .touchUpInside)
        let finishedReadingBtn = UIBarButtonItem(customView: finishedReadingBtnView)
        finishedReadingBtn.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        finishedReadingBtn.customView?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // スペーサー
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let fixedItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedItem.width = 30
        
        // ツールバーに追加する
        toolbarItems = [closeBtn, flexibleItem, readingBtn, fixedItem, finishedReadingBtn]
        navigationController?.isToolbarHidden = false
    }
    
    @objc private func close() {
        hero.dismissViewController()
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
