//
//  ReadingListTableVC.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/06/09.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import XLPagerTabStrip
import RealmSwift

protocol TapOptionButtonDelegate: class {
    func showItemOption(item: ReadingItem)
}

class ReadingListTableVC: UITableViewController, IndicatorInfoProvider {
    
    private let cellIdentifier = "ListItemCell"
    let btn = UIButton(type: .custom)

    var itemInfo = IndicatorInfo(title: "View")
    
    weak var delegate: TapOptionButtonDelegate?
    private var presenter: ReadingListPresenterInput!
    
    // 表示するアイテムの配列
    private var displayItems: Results<ReadingItem>?
    
    init(style: UITableView.Style, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func inject(presenter: ReadingListPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        configureFloatingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: "ListItemCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
    }
    
    private func configureFloatingButton() {
        btn.frame = CGRect(x: 285, y: 485, width: 100, height: 100)
        btn.setTitle("All Defects", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 50
        btn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn.layer.borderWidth = 3.0
//        btn.addTarget(self,action: #selector(DestinationVC.buttonTapped), for: UIControlEvent.touchUpInside)
        view.addSubview(btn)
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        btn.frame.origin.y = scrollView.contentOffset.y
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
        cell?.configureView(row: indexPath.row, item: item)
        
        // 期限が迫っているものは対応する表示をする
        if item.isDueDateIsOneDayAfter() {
            cell?.redView()
        } else if item.isDueDateIsTwoDaysAfter() {
            cell?.yelloeView()
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let displayItem = displayItems![indexPath.row]
        let webItem = WebItem(url: displayItem.url, title: displayItem.title, imageUrl: displayItem.imageUrl)
        let wevNav = ArticleWebVC.articleWebVCInit(webItem: webItem)
        present(wevNav, animated: true, completion: nil)
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension ReadingListTableVC: ReadingListPresenterOutput {
    func updateList(results: Results<ReadingItem>) {
        displayItems = results
        tableView.reloadData()
    }
}
