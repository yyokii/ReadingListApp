//
//  DeletedListVC.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/07/13.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class DeletedListVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    private let cellIdentifier = "ListItemCell"
    
    private var displayItems: [ReadingItem]?
    
    /// ナビゲーション付きのwebviewを作成する
    class func deleteVCInit() -> DeletedListVC {
        let vc = UIStoryboard(name: "DeletedList", bundle: nil).instantiateInitialViewController() as! DeletedListVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        // 最近削除したものを上に表示するためにreverseにする
        displayItems = RealmManager.sharedInstance.readDeletedItems()?.reversed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ListItemCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
    }
}

extension DeletedListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let displayItem = displayItems![indexPath.row]
        let webItem = WebItem(url: displayItem.url, title: displayItem.title, imageUrl: displayItem.imageUrl)
        let wevNav = ArticleWebVC.articleWebVCInit(webItem: webItem)
        present(wevNav, animated: true, completion: nil)
    }
}

extension DeletedListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListItemCell
        let item = displayItems![indexPath.row]
        cell?.configureView(row: indexPath.row, item: item, type: .DeletedList)
        cell?.selectionStyle = .none
        return cell!
    }
}
