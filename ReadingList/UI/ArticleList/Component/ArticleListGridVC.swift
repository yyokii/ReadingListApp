////
////  ArticleListGridVC.swift
////  ReadingList
////
////  Created by Yoki Higashihara on 2019/06/02.
////  Copyright © 2019 Yoki Higashihara. All rights reserved.
////
//
//import UIKit
//import Hero
//
//class ArticleListGridVC: UIViewController {
//
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        let width = view.frame.width
//        let holizontalyMargin: CGFloat = 8
//        let interItemSpacing:CGFloat = 8
//
//        flowLayout.itemSize = CGSize(width:width / 2 - holizontalyMargin*2 - interItemSpacing, height:100)
//        flowLayout.sectionInset = UIEdgeInsets(top: 8,left: holizontalyMargin,bottom: 0,right: holizontalyMargin)
//        flowLayout.minimumInteritemSpacing = interItemSpacing
//
//        collectionView.register(UINib(nibName: "ArticleItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArticleItemCollectionViewCell")
//    }
//
//    @IBAction func toList(_ sender: Any) {
//        let next = (UIStoryboard(name: "ArticleList", bundle: nil).instantiateViewController(withIdentifier: "ArticleListTable") as? ArticleListTableVC)!
//        _ = next.view
//        next.articleTableView.contentOffset.y = collectionView!.contentOffset.y + collectionView!.contentInset.top
//        hero.replaceViewController(with: next)
//    }
//}
//
//
//extension ArticleListGridVC: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleItemCollectionViewCell", for: indexPath as IndexPath) as! ArticleItemCollectionViewCell
//        cell.hero.modifiers = [.fade, .translate(y:20)]
//        return cell
//    }
//}
//
//extension ArticleListGridVC: UICollectionViewDelegate {
//
//}
//
//extension ArticleListGridVC: HeroViewControllerDelegate {
//    func heroWillStartAnimatingTo(viewController: UIViewController) {
//        //        if let _ = viewController as? ImageViewController,
//        //            let index = collectionView!.indexPathsForSelectedItems?[0],
//        //            let cell = collectionView!.cellForItem(at: index) as? GridImageCell {
//        //            let cellPos = view.convert(cell.imageView.center, from: cell)
//        //            collectionView!.hero.modifiers = [.scale(3), .translate(x:view.center.x - cellPos.x, y:view.center.y + collectionView!.contentInset.top/2/3 - cellPos.y), .ignoreSubviewModifiers, .fade]
//        //        } else {
//        collectionView.hero.modifiers = [.cascade]
//        //        }
//    }
//
//    func heroWillStartAnimatingFrom(viewController: UIViewController) {
//        //        if let vc = viewController as? ImageViewController,
//        //            let originalCellIndex = vc.selectedIndex,
//        //            let currentCellIndex = vc.collectionView?.indexPathsForVisibleItems[0] {
//        //            collectionView!.hero.modifiers = [.cascade]
//        //            if !collectionView!.indexPathsForVisibleItems.contains(currentCellIndex) {
//        //                // make the cell visible
//        //                collectionView!.scrollToItem(at: currentCellIndex,
//        //                                             at: originalCellIndex < currentCellIndex ? .bottom : .top,
//        //                                             animated: false)
//        //            }
//        //        } else {
//        collectionView.hero.modifiers = [.cascade, .delay(0.2)]
//        //        }
//    }
//}
