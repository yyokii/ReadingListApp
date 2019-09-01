//
//  ArticleListVC.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/05/12.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import Hero

class ArticleListVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private var presenter: ArticleListPresenterInput!
    
    private lazy var indicator = Indicator.init(frame: view.frame)
    private var articles: [Article]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureColletionView()
        presenter.viewDidload()
        
//        NotificationManager.sharedInstance.testNotification(type: .OneDayBefore)
//        NotificationManager.sharedInstance.testNotification(type: .TwoDaysBefore)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    private func configureColletionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        let width = view.frame.width
        let holizontalyMargin: CGFloat = 2
        let interItemSpacing:CGFloat = 2
        
        flowLayout.itemSize = CGSize(width:width / 2 - holizontalyMargin*2 - interItemSpacing, height:300)
        flowLayout.sectionInset = UIEdgeInsets(top: 8,left: holizontalyMargin,bottom: 0,right: holizontalyMargin)
        flowLayout.minimumInteritemSpacing = interItemSpacing
        
        collectionView.register(UINib(nibName: "ArticleItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArticleItemCollectionViewCell")
    }
    
    func inject(presenter: ArticleListPresenterInput) {
        self.presenter = presenter
    }
    
    //    @IBAction func toList(_ sender: Any) {
    //        let next = (UIStoryboard(name: "ArticleList", bundle: nil).instantiateViewController(withIdentifier: "ArticleListTable") as? ArticleListTableVC)!
    //        _ = next.view
    //        next.articleTableView.contentOffset.y = collectionView!.contentOffset.y + collectionView!.contentInset.top
    //        hero.replaceViewController(with: next)
    //    }
    
}

extension ArticleListVC: ArticleListPresenterOutput {
    func displayTutorialDialog() {
        SwiftMessageUtil.showCenteredIconMessage(iconImage: UIImage.init(named: "footer_icon")!, title: "ようこそ「Yomu」へ！", body: "ダウンロードありがとうございます☺️\n「Yomu」は通知の来る最新のリーディングリストアプリです。\n他のアプリや「人気記事」から記事を「Yomu」へ追加し、読み忘れをなくしましょう！", buttonTitle: "OK")
    }
    
    func dismissIndicator() {
        guard let indicator = view.findSubview(withTag: Constant.ViewTag.indicator) else { return }
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            indicator.removeFromSuperview()
        }, completion: nil)
    }
    
    func showIndicator() {
        if let _ = view.findSubview(withTag: Constant.ViewTag.indicator) {
            return
        } else {
            view.addSubview(indicator)
        }
    }
    
    func showSuccessAddDialog() {
        SwiftMessageUtil.showIconTextMessage(type: .ToReadingList, iconText: "👍", title: "保存しました", message: "リーディングリストに記事を追加しました") 
    }
    
    func updateList(results: [Article]) {
        articles = results
        collectionView.reloadData()
    }
}

extension ArticleListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleItemCollectionViewCell", for: indexPath as IndexPath) as! ArticleItemCollectionViewCell
        if let articleDatas = articles {
            let article = articleDatas[indexPath.row]
            cell.article = article
            cell.tapAddAction = {[weak self] in
                self?.presenter.addReadingList(article: article)
            }
        }
        cell.hero.modifiers = [.fade, .translate(y:20)]
        return cell
    }
}

extension ArticleListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let displayItem = articles![indexPath.row]
        let webItem = WebItem(url: displayItem.url, title: displayItem.title, imageUrl: displayItem.imageUrl)
        let wevNav = ArticleWebVC.articleWebVCInit(webItem: webItem)
        present(wevNav, animated: true, completion: nil)
    }
}

extension ArticleListVC: HeroViewControllerDelegate {
    func heroWillStartAnimatingTo(viewController: UIViewController) {
        // collectionView.hero.modifiers = [.cascade]
    }
    
    func heroWillStartAnimatingFrom(viewController: UIViewController) {
        collectionView.hero.modifiers = [.cascade, .delay(0.2)]
    }
}
