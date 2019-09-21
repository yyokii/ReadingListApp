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
    func tapOptionBtn(item: ReadingItem)
    func viewDidLoad()
    func viewWillAppear()
}

protocol  HomePresenterOutput: AnyObject {
    func displayTutorialDialog()
    func showNoTodayDeleteItemsView()
    func showNoReadingItemsView()
    func displayReadingListDialog(item: ReadingItem)
    func displayUserData(dataViewModel: GraphViewModel)
    func updateTodayDeleteList(items: Results<ReadingItem>?)
    func updateReadingList(items: Results<ReadingItem>?)
}

final class  HomePresenter {
    private weak var view: HomePresenterOutput!
    private var model: HomeModelInput
    
    let notificationCenter = NotificationCenter.default
    
    private var optionTappedItem: ReadingItem!
    
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
        
        // リーディングリストの削除を検知
        notificationCenter.addObserver(self, selector: #selector(deleteItem), name: .deleteReadingItem, object: nil)
        // リーディングリストへの追加を検知
        notificationCenter.addObserver(self, selector: #selector(changeItemStateToFinished), name: .changeItemStateToFinishedReading, object: nil)
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
    
    @objc private func updateReadingList() {
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
    
    /// 削除アクションされたアイテムを削除しリストを更新
    @objc private func deleteItem() {
        model.deleteItem(readingItem: optionTappedItem)
        fetchAndUpdateList()
        notificationCenter.post(name: .dismissItemOption, object: nil)
    }
    
    /// アイテムを既読リストに戻しリストを更新
    @objc private func changeItemStateToFinished() {
        model.changeItemStateToReading(item: optionTappedItem)
        // リスト更新
        fetchAndUpdateList()
        // 既読リスト更新
        notificationCenter.post(name: .updateFinishedList, object: nil)
        notificationCenter.post(name: .dismissItemOption, object: nil)
    }
}

extension  HomePresenter: HomePresenterInput {
    
    func tapOptionBtn(item: ReadingItem) {
        optionTappedItem = item
        view.displayReadingListDialog(item: item)
    }
    
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
