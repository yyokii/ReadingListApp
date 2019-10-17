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
    
    private var presenter: DeletedListPresenterInput!
    
    private var displayItems: [ReadingItem] = [ReadingItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        presenter.viewWillAppear()
    }
    
    static func viewController() -> DeletedListVC {
        let vc = UIStoryboard(name: "DeletedList", bundle: nil).instantiateInitialViewController() as! DeletedListVC
        let deletedListModel = DeletedListModel()
        let presenter = DeletedListPresenter(view: vc, model: deletedListModel)
        vc.inject(presenter: presenter)
        
        return vc
    }
    
    func inject(presenter: DeletedListPresenterInput) {
        self.presenter = presenter
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        tableView.separatorStyle = .none
    }
}

extension DeletedListVC: DeletedListPresenterOutput {
    func updateDeletedList(items: [ReadingItem]) {
        displayItems = items
        tableView.reloadData()
    }
}

extension DeletedListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item = displayItems[indexPath.row]
        let vc = ArticleWebVC.viewController(item: item)
        present(vc, animated: true, completion: nil)
        
    }
}

extension DeletedListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 178
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as? ArticleTableViewCell {
            
            let item = displayItems[indexPath.row]
            cell.articleView.articleImage.image = nil
            cell.configureCell(row: indexPath.row, item: item, type: .DeletedList, tapOptionBtnAction: nil)
            
            cell.selectionStyle = .none
            
            return cell
        }
        return UITableViewCell()
    }
}
