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
    
    let redColor = UIColor(red: 221/255.0, green: 0/255.0, blue: 19/255.0, alpha: 1.0)
    let unselectedIconColor = UIColor(red: 73/255.0, green: 8/255.0, blue: 10/255.0, alpha: 1.0)
    
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
        settings.style.buttonBarBackgroundColor = redColor
        settings.style.buttonBarItemBackgroundColor = .blue
        settings.style.selectedBarBackgroundColor = UIColor.green
        settings.style.selectedBarHeight = 4.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ReadingListIconCell?, newCell: ReadingListIconCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.iconImage.tintColor = self?.unselectedIconColor
            newCell?.iconImage.tintColor = .gray
        }
        
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let model = ListModel()
        
        let readingListTableVC = ReadingListTableVC(style: .plain, itemInfo: IndicatorInfo(title: " HOME", image: UIImage(named: "home")))
        let presenter_1 = ReadingListPresenter(view: readingListTableVC, model: model)
        readingListTableVC.inject(presenter: presenter_1)
        
        let finishedListTableVC = FinishedListTableVC(style: .plain, itemInfo: IndicatorInfo(title: " TRENDING", image: UIImage(named: "trending")))
        let presenter_2 = FinishedListPresenter(view: finishedListTableVC, model: model)
        finishedListTableVC.inject(presenter: presenter_2)
        
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

