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
    
    var displayTodayDeleteItems: Results<ReadingItem>?
    
    private var presenter: TodayDeletePresenterInput!
    
    static func viewController() -> UIViewController {
        let todayDeleteVC = UIStoryboard(name: "TodayDelete", bundle: nil).instantiateInitialViewController() as! TodayDeleteTableVC
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
        
        navigationItem.title = "本日削除される未読記事"
        tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presenter.viewWillAppear()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 178
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return displayTodayDeleteItems?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as? ArticleTableViewCell {
            
            if let items = displayTodayDeleteItems {
                let item = items[indexPath.row]
                cell.configureCell(row: indexPath.row, item: item, type: .FinishedList, tapOptionBtnAction: nil)
            }
            
            return cell
        }
        return UITableViewCell()
    }
}

extension TodayDeleteTableVC: TodayDeletePresenterOutput {

    func updateTodayDeleteList(items: Results<ReadingItem>?) {
        displayTodayDeleteItems = items
        tableView.reloadData()
    }
}
