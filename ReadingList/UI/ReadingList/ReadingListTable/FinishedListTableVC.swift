//
//  FinishedListTableVC.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/06/09.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import XLPagerTabStrip
import RealmSwift

class FinishedListTableVC: UITableViewController, IndicatorInfoProvider {
    
    private let cellIdentifier = "ListItemCell"
    var itemInfo = IndicatorInfo(title: "View")
    
    weak var delegate: TapOptionButtonDelegate?
    private var presenter: FinishedListPresenterInput!
    
    // 表示するアイテムの配列
    private var displayItems: Results<ReadingItem>?
    
    init(style: UITableView.Style, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func inject(presenter: FinishedListPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: "ListItemCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayItems?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListItemCell
        let item = displayItems![indexPath.row]
        cell?.tapOptionBtnAction = {[weak self] in
            self?.presenter.optionTapped(item: item)
            self?.delegate?.showItemOption(item: item)
        }
        cell?.configureView(row: indexPath.row, title: item.title, url: item.url, date: item.createdDate)
        cell?.selectionStyle = .none
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wevNav = ArticleWebVC.articleWebVCInit(urlSrting: displayItems![indexPath.row].url)
        present(wevNav, animated: true, completion: nil)
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension FinishedListTableVC: FinishedListPresenterOutput {
    func updateList(results: Results<ReadingItem>) {
        displayItems = results
        tableView.reloadData()
    }
}
