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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    private func configureWebView() {
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        toolbarView.delegate = self
    }
}

extension ArticleWebVC: ArticleWebPresenterOutput {
    func updateActionBtnState() {
        // todo
    }
    
    func showAddReadinListBtn() {
        toolbarView.configureToReadingListBtn()
    }
    
    func showAddFinishedListBtn() {
        toolbarView.configureToFinishedListBtn()
    }
    
    func showSuccessAddReadingListDialog() {
        // todo
    }
    
    func showSuccessAddFinishedListDialog() {
        // todo
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
        
        if(velocity.y>0) {
            // 下にスクロール（ヘッダーフッターを隠す）
            UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions(), animations: {                self.navigationController?.setNavigationBarHidden(true, animated: true)
                
                self.toolBarBottomConstraint?.isActive = false
                self.toolBarBottomConstraint = self.toolbarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.toolBarHeight.constant)
                self.toolBarBottomConstraint?.isActive = true
                
            }, completion: nil)
            
        } else {
            // 上にスクロール（ヘッダーフッターを表示する）
            UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
                self.toolBarBottomConstraint?.isActive = false
                self.toolBarBottomConstraint = self.toolbarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
                self.toolBarBottomConstraint?.isActive = true
                
            }, completion: nil)
        }
    }
}

extension ArticleWebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}
