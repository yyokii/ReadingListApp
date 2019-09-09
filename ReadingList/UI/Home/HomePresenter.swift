//
//  HomePresenter.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol HomePresenterInput {
    func viewDidLoad()
    func viewWillAppear()
}

protocol  HomePresenterOutput: AnyObject {
    func displayTutorialDialog()
    func showNoTodayDeleteItemsView()
    func showNoReadingItemsView()
    func displayUserData(dataViewModel: GraphViewModel)
    func updateTodayDeleteList(items: Results<ReadingItem>?)
    func updateReadingList(items: Results<ReadingItem>?)
}

final class  HomePresenter {
    private weak var view: HomePresenterOutput!
    private var model: HomeModelInput
    
    private var expireOneDayItems: Results<ReadingItem>?
    private var expireTwoDaysItems: Results<ReadingItem>?
    private var expireThreeDaysItems: Results<ReadingItem>?
    private var expireFourDaysItems: Results<ReadingItem>?
    private var expireFiveDaysItems: Results<ReadingItem>?
    private var expireSixDaysItems: Results<ReadingItem>?
    private var expireSevenDaysItems: Results<ReadingItem>?
    
    init(view:  HomePresenterOutput, model: HomeModelInput) {
        self.view = view
        self.model = model
    }
    
    private func fetchUserData() {
        expireOneDayItems = model.expireOneDayItems()
        expireTwoDaysItems = model.expireTwoDaysItems()
        expireThreeDaysItems = model.expireThreeDaysItems()
        expireFourDaysItems = model.expireFourDaysItems()
        expireFiveDaysItems = model.expireFiveDaysItems()
        expireSixDaysItems = model.expireSixDaysItems()
        expireSevenDaysItems = model.expireSevenDaysItems()
        
        let dataViewModel = GraphViewModel(oneDayAfterCount: expireOneDayItems?.count ?? 0, twoDaysAfterCount: expireTwoDaysItems?.count ?? 0, threeDaysAfterCount: expireThreeDaysItems?.count ?? 0, fourDaysAfterCount: expireFourDaysItems?.count ?? 0, fiveDaysAfterCount: expireFiveDaysItems?.count ?? 0, sixDaysAfterCount: expireSixDaysItems?.count ?? 0, sevenDaysAfterCount: expireSevenDaysItems?.count ?? 0)
        
        view.displayUserData(dataViewModel: dataViewModel)
    }
    
    private func fetchAndUpdateList() {
        // 記事情報更新
        addReadingItem()
        
        // UI更新
        updateTodayDeleteList()
        updateReadingList()
    }
    
    private func updateTodayDeleteList() {
        let now = Date()
        let endOfDate = Date.endOfDayForDate(date: now)
        guard let date = endOfDate else { return }
        let todayDelete = expireOneDayItems?.filter("dueDate <= %@", date)
        if todayDelete?.count ?? 0 > 0 {
            view.updateTodayDeleteList(items: todayDelete)
        } else {
            view.showNoTodayDeleteItemsView()
        }
    }
    
    private func updateReadingList() {
        let items = model.fetchNotFinishedItems()
        if items?.count ?? 0 > 0 {
            view.updateReadingList(items: items)
        } else {
            view.showNoReadingItemsView()
        }
    }
    
    /// シェアしたものを確認してRealmに保存
    private func addReadingItem() {
        if let items = UserDefaultManager.shareInstance.fetchReadingItems() {
            model.addItemToRealm(from: items)
            // Userdefaultに保存している記事情報を削除
            UserDefaultManager.shareInstance.deleteReadingItems()
        }
    }
}

extension  HomePresenter: HomePresenterInput {
    func viewDidLoad() {
        if UserDefaultManager.shareInstance.isFirstOpenArticleView() {
            view.displayTutorialDialog()
            UserDefaultManager.shareInstance.setFirstOpenArticleView()
        }
    }
    
    func viewWillAppear() {
        fetchUserData()
        fetchAndUpdateList()
    }
}
