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
    func tapOptionBtn(item: ReadingListItem)
    func tapFinishedListOptionBtn(item: ReadingListItem)
    func tapDisplayTodayDeleteView()
    func tapMoveItemToFinishedList()
    func tapMoveItemToReadingList()
    func tapDeleteItem()
    func viewDidLoad()
    func viewWillAppear()
}

protocol  HomePresenterOutput {
    func displayTutorialDialog()
    func displayReadingListDialog(item: ReadingListItem)
    func displayFinishedListDialog(item: ReadingListItem)
    func displayUserData(viewData: GraphViewData)
    func displayTodayDeleteView(items: [ReadingListItem])
    func showNoTodayDeleteItemsView()
    func showNoReadingItemsView()
    func updateFinishedReadingList(items: [ReadingListItem])
    func updateTodayDeleteList(items: [ReadingListItem])
    func updateReadingList(items: [ReadingListItem])
}

final class  HomePresenter {
    private var view: HomePresenterOutput!
    private weak var authUsecase: AuthUseCaseProtocol!
    private weak var readingListUseCase:  ReadingListUseCaseProtocol!
    private var dataStore: DataStoreProtocol!
    
    let notificationCenter = NotificationCenter.default
    
    private var optionTappedItem: ReadingListItem!
    
    private var notFinishedItems: [ReadingListItem]!
    
    init(view: HomePresenterOutput, authUseCase: AuthUseCaseProtocol, readingListUseCase: ReadingListUseCaseProtocol, dataStore: DataStoreProtocol) {
        self.view = view
        self.authUsecase = authUseCase
        self.readingListUseCase = readingListUseCase
        self.dataStore = dataStore
        
        self.readingListUseCase.output = self
        self.authUsecase.output = self
        
        setupNotificationCenter()
    }
    
    private func setupNotificationCenter() {
        // アプリがフォアグラウンドになったことを検知
        notificationCenter.addObserver(
            self, selector: #selector(saveReadingItem), name: UIApplication.didBecomeActiveNotification, object: nil
        )
    }
    
    private func getTodayDeleteItems(from items: [ReadingListItem], now: Date) -> [ReadingListItem] {
        
        var readingItems: [ReadingListItem] = [ReadingListItem]()
        
        for item: ReadingListItem in items where item.differenceDay(fromDate: now) <= 1 {
            readingItems.append(item)
        }
        
        return readingItems
    }
    
    
    @objc private func saveReadingItem() {
        readingListUseCase.saveReadingItem()
    }
}

extension  HomePresenter: HomePresenterInput {
    
    func tapMoveItemToFinishedList() {
        guard let id = optionTappedItem.id else {
            return
        }
        readingListUseCase.finishReadingItem(id)
    }
    
    func tapMoveItemToReadingList() {
        
        guard let id = optionTappedItem.id else {
            return
        }
        readingListUseCase.saveToReadingList(id)
    }
    
    func tapDeleteItem() {
        guard let id = optionTappedItem.id else {
            return
        }
        readingListUseCase.deleteReadingItem(id)
    }
    
    func tapDisplayTodayDeleteView() {
        let items = getTodayDeleteItems(from: notFinishedItems, now: Date())
        view.displayTodayDeleteView(items: items)
    }
    
    func tapOptionBtn(item: ReadingListItem) {
        optionTappedItem = item
        view.displayReadingListDialog(item: item)
    }
    
    func tapFinishedListOptionBtn(item: ReadingListItem) {
        optionTappedItem = item
        view.displayFinishedListDialog(item: item)
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
    
    func didUpdateItemData() {
        readingListUseCase.fetchReadingItems()
    }
    
    func didUpdateReadingItemsData(_ items: [ReadingListItem]) {
        let viewData = GraphViewData(items: items)
        view.displayUserData(viewData: viewData)
    }
    
    func didUpdateFinishedReadingItems(_ items: [ReadingListItem]) {
        view.updateFinishedReadingList(items: items)
    }
    
    func didUpdateReadingItemsWillDelete(_ items: [ReadingListItem]) {
        
        if items.count > 0 {
            view.updateTodayDeleteList(items: items)
        } else {
            view.updateTodayDeleteList(items: [ReadingListItem]())
            view.showNoTodayDeleteItemsView()
        }
    }
    
    func didUpdateReadingItems(_ items: [ReadingListItem]) {
        
        if items.count > 0 {
            view.updateReadingList(items: items)
        } else {
            view.updateReadingList(items: [ReadingListItem]())
            view.showNoReadingItemsView()
        }
    }
}
