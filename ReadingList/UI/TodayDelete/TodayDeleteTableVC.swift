//
//  TodayDeleteTableVC.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/09/02.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import RealmSwift

class TodayDeleteTableVC: UITableViewController {
    
    var displayTodayDeleteItems: [ReadingItem]!
    
    private var presenter: TodayDeletePresenterInput!
    
    static func viewController(items: [ReadingItem]) -> UIViewController {
        let todayDeleteVC = UIStoryboard(name: "TodayDelete", bundle: nil).instantiateInitialViewController() as! TodayDeleteTableVC
        todayDeleteVC.displayTodayDeleteItems = items
        let todayDeleteModel = TodayDeleteModel()
        let todayDeletePresenter = TodayDeletePresenter(view: todayDeleteVC, model: todayDeleteModel)
        todayDeleteVC.inject(presenter: todayDeletePresenter)
        return todayDeleteVC
    }
    
    func inject(presenter: TodayDeletePresenterInput) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .black
        
        tableView.separatorStyle = .none
        
        navigationItem.title = "1日以内に削除される未読記事"
        tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 178
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayTodayDeleteItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as? ArticleTableViewCell {
            
            if let items = displayTodayDeleteItems {
                let item = items[indexPath.row]
                cell.articleView.articleImage.image = nil
                cell.configureCell(row: indexPath.row, item: item, type: .FinishedList, tapOptionBtnAction: nil)
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = displayTodayDeleteItems?[indexPath.row] {
            let vc = ArticleWebVC.viewController(item: item)
            present(vc, animated: true, completion: nil)
        }
    }
}

extension TodayDeleteTableVC: TodayDeletePresenterOutput {}
