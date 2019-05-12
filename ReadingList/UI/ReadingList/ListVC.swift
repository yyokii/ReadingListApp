//
//  ListVC.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/08.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import RealmSwift

class ListVC: UIViewController {
    @IBOutlet weak var testLbl: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    
    // 表示するアイテムの配列
    private var displayItems: Results<ReadingItem>?

    private var presenter: ListPresenterInput!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
        presenter.viewWillAppear()
    }
    
    func inject(presenter: ListPresenterInput) {
        self.presenter = presenter
    }
    
    private func configureView() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UINib(nibName: "ListItemCell", bundle: nil), forCellReuseIdentifier: "ListItemCell")

        navigationItem.title = "Reading List"
    }
}

extension ListVC: ListPresenterOutput {
    func updateList(results: Results<ReadingItem>) {
        displayItems = results
        listTableView.reloadData()
    }
}

extension ListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleVC = ArticleWebVC()
        // FIXME: 強制アンラップ
        articleVC.urlString = displayItems![indexPath.row].url
        navigationController?.pushViewController(articleVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let items = displayItems else { return }
        if editingStyle == .delete {
            presenter.deleteItem(readingItem: items[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath) as? ListItemCell
        let item = displayItems![indexPath.row]
        cell?.configureView(title: item.title, url: item.url, date: item.createdDate)
        return cell!
    }
}

