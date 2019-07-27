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
    private var noContentView: UIView!
    var itemInfo = IndicatorInfo(title: "View")

    weak var delegate: TapOptionButtonDelegate?
    private var presenter: ReadingListPresenterInput!
    // 表示するアイテムの配列
    private var displayItems: [ReadingItem]?
    
    // リフレッシュのアニメーション関連
//    var labelsArray: Array<UILabel> = []
//    var isAnimating = false
//    var currentColorIndex = 0
//    var currentLabelIndex = 0
    
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
        NotificationManager.sharedInstance.requestAuthorize()
        
        noContentView = NoReadingListItemView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        configureTableView()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: "ListItemCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        
//        refreshControl = UIRefreshControl()
//        tableView.addSubview(refreshControl!)
//        refreshControl!.backgroundColor = UIColor.clear
//        refreshControl!.tintColor = UIColor.clear
//        loadCustomRefreshContents()
    }
    
    // MARK: UITableViewDataSource
    
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
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let displayItem = displayItems![indexPath.row]
        let webItem = WebItem(url: displayItem.url, title: displayItem.title, imageUrl: displayItem.imageUrl)
        let wevNav = ArticleWebVC.articleWebVCInit(webItem: webItem)
        present(wevNav, animated: true, completion: nil)
    }
    
    // MARK: UIScrollView delegate method implementation
    
//    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if refreshControl!.isRefreshing && !isAnimating {
//            guard let items = displayItems else { return }
//
//            displayItems = items.shuffled()
//            tableView.reloadData()
//            refreshControl?.endRefreshing()
//        }
//    }
    
    // MARK: IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    // MARK: リフレッシュコントロールのカスタム
    
//    func loadCustomRefreshContents() {
//        let refreshContents = Bundle.main.loadNibNamed("RefreshContents", owner: self, options: nil)
//
//        let refreshCustomView = refreshContents![0] as! UIView
//        refreshCustomView.frame = refreshControl!.bounds
//
//        for i in 0 ..< refreshCustomView.subviews.count {
//            labelsArray.append(refreshCustomView.viewWithTag(i + 1) as! UILabel)
//        }
//
//        refreshControl!.addSubview(refreshCustomView)
//    }
    
//    func animateRefreshStep1() {
//        isAnimating = true
//
//        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: { () -> Void in
//            self.labelsArray[self.currentLabelIndex].transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi/4))
//            self.labelsArray[self.currentLabelIndex].textColor = self.getNextColor()
//
//        }, completion: { (finished) -> Void in
//
//            UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveLinear, animations: { () -> Void in
//                self.labelsArray[self.currentLabelIndex].transform = CGAffineTransform.identity
//                self.labelsArray[self.currentLabelIndex].textColor = UIColor.black
//
//            }, completion: { (finished) -> Void in
//                self.currentLabelIndex += 1
//
//                if self.currentLabelIndex < self.labelsArray.count {
//                    // 文字数分のアニメーションを行う、順番に傾き・色変えのいアニメーション実行
//                    self.animateRefreshStep1()
//                }
//                else {
//                    self.animateRefreshStep2()
//                }
//            })
//        })
//    }
    
    
//    func animateRefreshStep2() {
//        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveLinear, animations: { () -> Void in
//            self.labelsArray[0].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//            self.labelsArray[1].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//            self.labelsArray[2].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//            self.labelsArray[3].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//            self.labelsArray[4].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//            self.labelsArray[5].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//            self.labelsArray[6].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//
//        }, completion: { (finished) -> Void in
//            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: { () -> Void in
//                self.labelsArray[0].transform = CGAffineTransform.identity
//                self.labelsArray[1].transform = CGAffineTransform.identity
//                self.labelsArray[2].transform = CGAffineTransform.identity
//                self.labelsArray[3].transform = CGAffineTransform.identity
//                self.labelsArray[4].transform = CGAffineTransform.identity
//                self.labelsArray[5].transform = CGAffineTransform.identity
//                self.labelsArray[6].transform = CGAffineTransform.identity
//
//            }, completion: { (finished) -> Void in
//                if self.refreshControl!.isRefreshing {
//                    self.currentLabelIndex = 0
//                    self.animateRefreshStep1()
//                }
//                else {
//                    self.isAnimating = false
//                    self.currentLabelIndex = 0
//                    for i in 0..<self.labelsArray.count {
//                        self.labelsArray[i].textColor = UIColor.black
//                        self.labelsArray[i].transform = CGAffineTransform.identity
//                    }
//                }
//            })
//        })
//    }
    
    
//    func getNextColor() -> UIColor {
//        // 7色、文字数と同じ
//        var colorsArray: Array<UIColor> = [UIColor.init(named: Constant.Color.bisque)!, UIColor.init(named: Constant.Color.caramel)!, UIColor.init(named: Constant.Color.greenSheen)!, UIColor.init(named: Constant.Color.myrtleGreen)!, UIColor.init(named: Constant.Color.pinkSherbet)!, UIColor.init(named: Constant.Color.sugarPlum)!, UIColor.init(named: Constant.Color.bisque)!]
//
//        if currentColorIndex == colorsArray.count {
//            // 先頭に戻る
//            currentColorIndex = 0
//        }
//
//        let returnColor = colorsArray[currentColorIndex]
//        currentColorIndex += 1
//
//        return returnColor
//    }
}

extension ReadingListTableVC: ReadingListPresenterOutput {
    func dismissNoContentView() {
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: { [weak self] in
            guard let self = self else { return }
            self.noContentView.removeFromSuperview()
            }, completion: nil)
    }
    
    func displayNoContentView() {
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: { [weak self] in
            guard let self = self else { return }
            self.view.addSubview(self.noContentView)
            }, completion: nil)
    }
    
    func updateList(results: [ReadingItem]) {
        displayItems = results
        tableView.reloadData()
    }
}
