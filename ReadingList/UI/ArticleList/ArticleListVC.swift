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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let width = view.frame.width
        let holizontalyMargin: CGFloat = 8
        let interItemSpacing:CGFloat = 8

        flowLayout.itemSize = CGSize(width:width / 2 - holizontalyMargin*2 - interItemSpacing, height:100)
        flowLayout.sectionInset = UIEdgeInsets(top: 8,left: holizontalyMargin,bottom: 0,right: holizontalyMargin)
        flowLayout.minimumInteritemSpacing = interItemSpacing

        collectionView.register(UINib(nibName: "ArticleItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArticleItemCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FirebaseManager.sharedInstance.fetchRssArticles { articles in
            print("test")
        }
    }
    
    @IBAction func toList(_ sender: Any) {
        let next = (UIStoryboard(name: "ArticleList", bundle: nil).instantiateViewController(withIdentifier: "ArticleListTable") as? ArticleListTableVC)!
        _ = next.view
        next.articleTableView.contentOffset.y = collectionView!.contentOffset.y + collectionView!.contentInset.top
        hero.replaceViewController(with: next)
    }
}


extension ArticleListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleItemCollectionViewCell", for: indexPath as IndexPath) as! ArticleItemCollectionViewCell
        cell.hero.modifiers = [.fade, .translate(y:20)]
        return cell
    }
}

extension ArticleListVC: UICollectionViewDelegate {

}

extension ArticleListVC: HeroViewControllerDelegate {
    func heroWillStartAnimatingTo(viewController: UIViewController) {
            collectionView.hero.modifiers = [.cascade]
    }

    func heroWillStartAnimatingFrom(viewController: UIViewController) {
            collectionView.hero.modifiers = [.cascade, .delay(0.2)]
    }
}
