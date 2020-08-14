//
//  FloatingViewPresenter.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/09/01.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol FloatingViewPresenterInput {
    func optionTapped(item: ReadingListItem)
    func viewWillAppear()
}

protocol FloatingViewPresenterOutput: AnyObject {
    func updateList(results: [ReadingListItem])
    func displayFinishedListDialog(item: ReadingListItem)
    func displayNoContentView()
    func dismissNoContentView()
}

final class  FloatingViewPresenter {
    private weak var view: FloatingViewPresenterOutput!
    private var model: FloatingViewModelInput
    
    // オプションをタップされたアイテム
    var optionTappedItem: ReadingListItem!
    
    let notificationCenter = NotificationCenter.default
    
    init(view:  FloatingViewPresenterOutput, model: FloatingViewModelInput) {
        self.view = view
        self.model = model
        
        // （オプションボタンのアクション）アイテム削除を検知
        notificationCenter.addObserver(self, selector: #selector(deleteItem), name: .deleteFinishedItem, object: nil)
        // （オプションボタンのアクション）リーディングリストへの移動を検知
        notificationCenter.addObserver(self, selector: #selector(changeItemStateToReading), name: .changeItemStateToReading, object: nil)
        // 既読リストの更新依頼を検知
        notificationCenter.addObserver(self, selector: #selector(fetchFinishedList), name: .updateFinishedList, object: nil)
    }
    
    @objc private func fetchFinishedList() {
        let items = model.fetchFinishedItems()
        if items.count == 0 {
            view.updateList(results: items)
            // view.displayNoContentView()
        } else {
            view.updateList(results: items)
            // view.dismissNoContentView()
        }
    }
    
    /// 削除アクションされたアイテムを削除しリストを更新
    @objc private func deleteItem() {
        model.deleteItem(readingItem: optionTappedItem)
        fetchFinishedList()
    }
    
    /// アイテムをリーディングリストに戻し更新
    @objc private func changeItemStateToReading() {
        
        NotificationManager.addNotification(item: optionTappedItem, type: .OneDayBefore)
        NotificationManager.addNotification(item: optionTappedItem, type: .TwoDaysBefore)

        model.changeItemStateToReading(item: optionTappedItem)
        
        // 既読リスト更新
        fetchFinishedList()
        // リーディングリスト更新
        notificationCenter.post(name: .updateReadingList, object: nil)
    }
}

extension  FloatingViewPresenter: FloatingViewPresenterInput {
    func optionTapped(item: ReadingListItem) {
        optionTappedItem = item
        view.displayFinishedListDialog(item: item)
    }
    
    func viewWillAppear() {
        fetchFinishedList()
    }
}
