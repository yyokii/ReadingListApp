//
//  ArticleListTableVC.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/05/30.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

// 現状未使用。グリッドとの切り替えに使用したい。

import UIKit
import Hero

class ListTableViewCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame.origin.x = 0
        imageView?.frame.size = CGSize(width: bounds.height, height: bounds.height)
        textLabel?.frame.origin.x = bounds.height + 10
        detailTextLabel?.frame.origin.x = bounds.height + 10
    }
}

class ArticleListTableVC: UIViewController {
    @IBOutlet weak var articleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        articleTableView.delegate = self
        articleTableView.dataSource = self
    }
    
    @IBAction func toGrid(_ sender: Any) {
        let next = (UIStoryboard(name: "ArticleList", bundle: nil).instantiateViewController(withIdentifier: "ArticleList") as? ArticleListVC)!
        _ = next.view
        next.collectionView.contentOffset.y = articleTableView.contentOffset.y + articleTableView.contentInset.top
        hero.replaceViewController(with: next)
    }
}

extension ArticleListTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        
        cell.hero.modifiers = [.fade, .translate(x:-100)]
//        cell.imageView!.hero.id = "image_\(indexPath.item)"
//        cell.imageView!.hero.modifiers = [.arc]
//        cell.imageView!.image = ImageLibrary.thumbnail(index:indexPath.item)
//        cell.imageView!.isOpaque = true
        cell.textLabel!.text = "Item \(indexPath.item)"
        // cell.detailTextLabel!.text = "Description \(indexPath.item)"
        
        return cell
    }
}

extension ArticleListTableVC: HeroViewControllerDelegate {
    func heroWillStartAnimatingTo(viewController: UIViewController) {
        if let _ = viewController as? ArticleListVC {
            articleTableView.hero.modifiers = [.ignoreSubviewModifiers]
        } else {
            articleTableView.hero.modifiers = [.cascade]
        }
    }
    func heroWillStartAnimatingFrom(viewController: UIViewController) {
        if let _ = viewController as? ArticleListVC {
            articleTableView.hero.modifiers = [.ignoreSubviewModifiers]
        } else {
            articleTableView.hero.modifiers = [.cascade]
        }
//        if let vc = viewController as? ImageViewController,
//            let originalCellIndex = vc.selectedIndex,
//            let currentCellIndex = vc.collectionView?.indexPathsForVisibleItems[0] {
//            if tableView.indexPathsForVisibleRows?.contains(currentCellIndex) != true {
//                // make the cell visible
//                tableView.scrollToRow(at: currentCellIndex,
//                                      at: originalCellIndex < currentCellIndex ? .bottom : .top,
//                                      animated: false)
//            }
//        }
    }
}
