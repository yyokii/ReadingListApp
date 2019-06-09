////
////  ListVC.swift
////  ReadingList
////
////  Created by Yoki Higashihara on 2019/04/08.
////  Copyright © 2019 Yoki Higashihara. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//class ListVC: UIViewController {
//    @IBOutlet weak var listTableView: UITableView!
//    @IBOutlet weak var readingItemButton: UIButton!
//    @IBOutlet weak var finishedItemButton: UIButton!
//    
//    // 表示するアイテムの配列
//    private var displayItems: Results<ReadingItem>?
//
//    private var presenter: ListPresenterInput!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureView()
//        presenter.viewDidLoad()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.isToolbarHidden = true
//        presenter.viewWillAppear()
//    }
//    
//    func inject(presenter: ListPresenterInput) {
//        self.presenter = presenter
//    }
//    
//    private func configureView() {
//        listTableView.delegate = self
//        listTableView.dataSource = self
//        listTableView.register(UINib(nibName: "ListItemCell", bundle: nil), forCellReuseIdentifier: "ListItemCell")
//
//        navigationItem.title = "Reading List"
//        configureReadingItemButton()
//    }
//    @IBAction func tappedReadingItemButton(_ sender: Any) {
//        presenter.tapReadingItemButton()
//    }
//    
//    @IBAction func tappedFinishedItemButton(_ sender: Any) {
//        presenter.tapFinishedItemButton()
//    }
//}
//
//extension ListVC: ListPresenterOutput {
//    func configureReadingItemButton() {
//        readingItemButton.isEnabled = false
//        finishedItemButton.isEnabled = true
//    }
//    
//    func configureFinishedItemButton() {
//        readingItemButton.isEnabled = true
//        finishedItemButton.isEnabled = false
//    }
//    
//    func updateList(results: Results<ReadingItem>) {
//        displayItems = results
//        listTableView.reloadData()
//    }
//}
//
//extension ListVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let articleVC = ArticleWebVC.articleWebVCInit(urlSrting: displayItems![indexPath.row].url)
//        present(articleVC, animated: true, completion: nil)
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        guard let items = displayItems else { return }
//        if editingStyle == .delete {
//            presenter.deleteItem(readingItem: items[indexPath.row])
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//}
//
//extension ListVC: UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return displayItems?.count ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath) as? ListItemCell
//        let item = displayItems![indexPath.row]
//        cell?.configureView(title: item.title, url: item.url, date: item.createdDate)
//        cell?.selectionStyle = .none
//        return cell!
//    }
//}
//
