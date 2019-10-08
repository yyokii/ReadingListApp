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
    func updateTodayDeleteList(items: [ReadingItem]?)
    func updateReadingList(items: [ReadingItem]?)
}

final class  HomePresenter {
    private weak var view: HomePresenterOutput!
    private var model: HomeModelInput
    
    let notificationCenter = NotificationCenter.default
    
    private var optionTappedItem: ReadingItem!
    
    private var notFinishedItems: Results<ReadingItem>?
    
    init(view:  HomePresenterOutput, model: HomeModelInput) {
        self.view = view
        self.model = model
        
        // （オプションボタンのアクション）リーディングリストの削除を検知
        notificationCenter.addObserver(self, selector: #selector(deleteItem), name: .deleteReadingItem, object: nil)
        // （オプションボタンのアクション）既読リストへの追加を検知
        notificationCenter.addObserver(self, selector: #selector(changeItemStateToFinished), name: .changeItemStateToFinishedReading, object: nil)
        notificationCenter.addObserver(self, selector: #selector(fetchAndUpdateList), name: .updateReadingList, object: nil)
    }
    
    private func updateUserData(items: Results<ReadingItem>?) {

        guard let readingItems = items else {
            return
        }
        
        let dataViewModel = GraphViewModel(items: readingItems)
        
        view.displayUserData(dataViewModel: dataViewModel)
    }
    
    @objc private func fetchAndUpdateList() {
        
        // 記事情報更新
        addReadingItem()
        // 未読アイテム取得
        notFinishedItems = model.fetchNotFinishedItems()
        let now = Date()
        
        // グラフとリスト更新
        updateUserData(items: notFinishedItems)
        updateTodayDeleteList(now: now, notFinishedItems: notFinishedItems)
        updateReadingList(now: now)
    }
    
    private func updateTodayDeleteList(now: Date, notFinishedItems: Results<ReadingItem>?) {
        
        guard let items = notFinishedItems else {
            view.updateTodayDeleteList(items: nil)
            view.showNoTodayDeleteItemsView()
            return
        }
        
        var todayDeleteItems: [ReadingItem] = [ReadingItem]()
        
        for item: ReadingItem in items where item.differenceDay(fromDate: now) <= 1 {
            // 1日以内に削除される記事
            todayDeleteItems.append(item)
        }

        if todayDeleteItems.count > 0 {
            view.updateTodayDeleteList(items: todayDeleteItems)
        } else {
            view.updateTodayDeleteList(items: nil)
            view.showNoTodayDeleteItemsView()
        }
    }
    
    @objc private func updateReadingList(now: Date) {
        
        guard let items = notFinishedItems else {
            view.updateReadingList(items: nil)
            view.showNoReadingItemsView()
            return
        }
        
        var readingItems: [ReadingItem] = [ReadingItem]()
        
        for item: ReadingItem in items where item.differenceDay(fromDate: now) > 1 {
            readingItems.append(item)
        }
        
        if readingItems.count > 0 {
            view.updateReadingList(items: readingItems)
        } else {
            view.updateReadingList(items: nil)
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
        
        NotificationManager.sharedInstance.deleteNotification(item: optionTappedItem)
        model.deleteItem(readingItem: optionTappedItem)
        
        fetchAndUpdateList()
    }
    
    /// アイテムを既読リストに移しリストを更新
    @objc private func changeItemStateToFinished() {
        
        NotificationManager.sharedInstance.deleteNotification(item: optionTappedItem)
        model.changeItemStateToReading(item: optionTappedItem)
        // リスト更新
        fetchAndUpdateList()
        // 既読リスト更新
        notificationCenter.post(name: .updateFinishedList, object: nil)
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
        fetchAndUpdateList()
    }
}
