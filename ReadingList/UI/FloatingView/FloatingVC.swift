//
//  FloatingVC.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/30.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import RealmSwift

class FloatingVC: UIViewController {

    @IBOutlet weak var articleTableView: UITableView!
    
    // 表示するアイテムの配列
    private var displayItems: Results<ReadingItem>?
    private var presenter: FloatingViewPresenterInput!
    
    func inject(presenter: FloatingViewPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleTableView.dataSource = self
        articleTableView.delegate = self
        
        articleTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }
    
    private func displayItemOption() {
        SwiftMessageUtil.showWebHowtoView()
        // performSegue(withIdentifier: "FinishedItemOption", sender: nil)
    }
}

extension FloatingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 178
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = displayItems {
            return items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as? ArticleTableViewCell {
            
            if let items = displayItems {
                let item = items[indexPath.row]
                let optionTappedAction = {
                    self.presenter.optionTapped(item: item)
                }
                cell.configureCell(row: indexPath.row, item: item, type: .FinishedList, tapOptionBtnAction: optionTappedAction)
            }
        
            return cell
        }
        return UITableViewCell()
    }
}

extension FloatingVC: UITableViewDelegate {
    
}

extension FloatingVC: FloatingViewPresenterOutput {
    func displayFinishedListDialog(item: ReadingItem) {
        SwiftMessageUtil.showFinishedListDialog(title: item.title)
    }
    
    func updateList(results: Results<ReadingItem>) {
        displayItems = results
    }
    
    func displayNoContentView() {
    }
    
    func dismissNoContentView() {
    }
}
