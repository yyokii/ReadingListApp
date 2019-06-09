//
//  TableChildVC.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/06/09.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import XLPagerTabStrip
import RealmSwift

class TableChildVC: UITableViewController, IndicatorInfoProvider {
    
    private let cellIdentifier = "postCell"
    var itemInfo = IndicatorInfo(title: "View")
    private var presenter: ListPresenterInput!

    init(style: UITableView.Style, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func inject(presenter: ListPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PostCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 600.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataProvider.sharedInstance.postsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PostCell,
            let data = DataProvider.sharedInstance.postsData.object(at: indexPath.row) as? NSDictionary else { return PostCell() }
        
        cell.configureWithData(data)
        return cell
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension TableChildVC: ListPresenterOutput {
    func configureReadingItemButton() {
    }
    
    func configureFinishedItemButton() {
    }
    
    func updateList(results: Results<ReadingItem>) {
    }
}
