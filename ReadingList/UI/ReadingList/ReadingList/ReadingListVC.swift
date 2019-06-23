//
//  ReadingListVC.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/06/09.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ReadingListVC: BaseButtonBarPagerTabStripViewController<ReadingListIconCell> {
    @IBOutlet weak var statusBarBackView: UIView!
    
    var tappedItem: ReadingItem?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        buttonBarItemSpec = ButtonBarItemSpec.nibFile(nibName: "ReadingListIconCell", bundle: Bundle(for: ReadingListIconCell.self), width: { _ in
            return 55.0
        })
    }
    
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = UIColor.init(named: Constant.Color.myrtleGreen)
        settings.style.selectedBarBackgroundColor = UIColor.init(named: Constant.Color.bisque)!
        settings.style.selectedBarHeight = 6.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ReadingListIconCell?, newCell: ReadingListIconCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.iconImage.tintColor = UIColor.black
            newCell?.iconImage.tintColor = .white
        }
        
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    @objc private func showItemOptionVC(notification: Notification) {
        if let tappedRow = notification.userInfo?["row"] as? Int {
            performSegue(withIdentifier: "ItemOption", sender: tappedRow)
        }
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let model = ListModel()
        
        let readingListTableVC = ReadingListTableVC(style: .plain, itemInfo: IndicatorInfo(title: " HOME", image: UIImage(named: "reading")))
        let presenter_1 = ReadingListPresenter(view: readingListTableVC, model: model)
        readingListTableVC.inject(presenter: presenter_1)
        readingListTableVC.delegate = self
        
        let finishedListTableVC = FinishedListTableVC(style: .plain, itemInfo: IndicatorInfo(title: " TRENDING", image: UIImage(named: "reading_finished")))
        let presenter_2 = FinishedListPresenter(view: finishedListTableVC, model: model)
        finishedListTableVC.inject(presenter: presenter_2)
        finishedListTableVC.delegate = self
        
        return [readingListTableVC, finishedListTableVC]
    }
    
    override func configure(cell: ReadingListIconCell, for indicatorInfo: IndicatorInfo) {
        cell.iconImage.image = indicatorInfo.image?.withRenderingMode(.alwaysTemplate)
    }
    
    // MARK: - Actions
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ReadingListVC: TapOptionButtonDelegate {
    func showItemOption(item: ReadingItem) {
        tappedItem = item
        if let _ = item.finishedDate {
            // 読み終わっている場合
            performSegue(withIdentifier: "FinishedItemOption", sender: nil)
        } else {
            // リーディングリストのアイテムの場合
            performSegue(withIdentifier: "ReadingItemOption", sender: nil)
        }
    }
}
