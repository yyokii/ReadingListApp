//
//  HomePresenter.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol HomePresenterInput: AnyObject {
    func tapOptionBtn(item: ReadingItem)
    func tapDisplayTodayDeleteView()
    func viewDidLoad()
    func viewWillAppear()
}

protocol  HomePresenterOutput: AnyObject {
    func displayTutorialDialog()
    func displayReadingListDialog(item: ReadingItem)
    func displayUserData(dataViewModel: GraphViewModel)
    func displayTodayDeleteView(items: [ReadingItem])
    func showNoTodayDeleteItemsView()
    func showNoReadingItemsView()
    func updateTodayDeleteList(items: [ReadingItem]?)
    func updateReadingList(items: [ReadingItem]?)
}

final class  HomePresenter {
    private var view: HomePresenterOutput!
    private weak var authUsecase: AuthUseCaseProtocol!
    private weak var readingListUseCase:  ReadingListUseCaseProtocol!
    private var dataStore: DataStoreProtocol!
    
    // TODO: これなくしたいなあ
    private var model: HomeModelInput
    
    let notificationCenter = NotificationCenter.default
    
    private var optionTappedItem: ReadingItem!
    
    private var notFinishedItems: Results<ReadingItem>?
    
    init(view:  HomePresenterOutput, authUseCase: AuthUseCaseProtocol, readingListUseCase: ReadingListUseCaseProtocol, dataStore: DataStoreProtocol, model: HomeModelInput) {
        self.view = view
        self.authUsecase = authUseCase
        self.readingListUseCase = readingListUseCase
        self.dataStore = dataStore
        
        self.model = model
        
        self.readingListUseCase.output = self
        self.authUsecase.output = self
        
        setupNotificationCenter()
    }
    
    private func setupNotificationCenter() {
        // TODO: 不要な気がするから削除したい
        // （オプションボタンのアクション）リーディングリストの削除を検知
        notificationCenter.addObserver(self, selector: #selector(deleteItem), name: .deleteReadingItem, object: nil)
        // （オプションボタンのアクション）既読リストへの追加を検知
        notificationCenter.addObserver(self, selector: #selector(changeItemStateToFinished), name: .changeItemStateToFinishedReading, object: nil)
        notificationCenter.addObserver(self, selector: #selector(fetchAndUpdateList), name: .updateReadingList, object: nil)
        
        // アプリがフォアグラウンドになってことを検知
        notificationCenter.addObserver(
            self, selector: #selector(saveReadingItem), name: UIApplication.didBecomeActiveNotification, object: nil
        )
    }
    
    private func updateUserData(items: Results<ReadingItem>?) {
        
        guard let readingItems = items else {
            return
        }
        
        let dataViewModel = GraphViewModel(items: readingItems)
        
        view.displayUserData(dataViewModel: dataViewModel)
    }
    
    @objc private func fetchAndUpdateList() {
        
        // 記事情報更新 // TODO: viewWillappearでもuserdefult見にいく必要ある？多分ない
        saveReadingItem()
        // 未読アイテム取得
        notFinishedItems = model.fetchNotFinishedItems()
        let now = Date()
        
        // グラフとリスト更新
        updateUserData(items: notFinishedItems)
        updateTodayDeleteList(now: now, notFinishedItems: notFinishedItems)
        updateReadingList(now: now)
    }
    
    private func updateTodayDeleteList(now: Date, notFinishedItems: Results<ReadingItem>?) {
        
        let todayDeleteItems: [ReadingItem] = getTodayDeleteItems(from: notFinishedItems, now: now)
        
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
    
    private func getTodayDeleteItems(from items: Results<ReadingItem>?, now: Date) -> [ReadingItem] {
        
        var readingItems: [ReadingItem] = [ReadingItem]()
        
        guard let items = items else {
            return readingItems
        }
        for item: ReadingItem in items where item.differenceDay(fromDate: now) <= 1 {
            readingItems.append(item)
        }
        
        return readingItems
    }
    
    
    @objc private func saveReadingItem() {
        readingListUseCase.saveReadingItem()
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
    
    func tapDisplayTodayDeleteView() {
        let items = getTodayDeleteItems(from: notFinishedItems, now: Date())
        view.displayTodayDeleteView(items: items)
    }
    
    func tapOptionBtn(item: ReadingItem) {
        optionTappedItem = item
        view.displayReadingListDialog(item: item)
    }
    
    func viewDidLoad() {
        if dataStore.isFirstOpenArticleView() {
            // 初回表示時
            view.displayTutorialDialog()
            dataStore.setFirstOpenArticleView()
        }
        
        authUsecase.fetchUser()
    }
    
    func viewWillAppear() {}
}

extension HomePresenter: AuthUseCaseOutput {
    
    func didFetchUser() {
        readingListUseCase.fetchReadingItems()
    }
    
    func didsignIn(_ repoStatuses: String) {
    }
    
    func useCaseDidReceiveError(_ error: WebClientError) {
    }
}

extension HomePresenter: ReadingListUseCaseOutput {
    
    func didUpdateFinishedReadingItems(_ items: [ReadingListItem]) {
    }
    
    func didUpdateReadingItemsWillDelete(_ items: [ReadingListItem]) {
    }
    
    func didUpdateReadingItems(_ items: [ReadingListItem]) {
        // TODO: 値の取得は確認できたので、表示対応をする
        print("-----------")
        print(items)
    }
    
    func didSaveReadingItem() {
    }
    
    func useCaseDidReceiveError(_ error: Error) {
    }
}
