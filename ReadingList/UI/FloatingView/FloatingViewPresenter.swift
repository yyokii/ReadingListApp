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
    func optionTapped(item: ReadingItem)
    func viewWillAppear()
}

protocol FloatingViewPresenterOutput: AnyObject {
    func updateList(results: Results<ReadingItem>)
    func displayFinishedListDialog(item: ReadingItem)
    func displayNoContentView()
    func dismissNoContentView()
}

final class  FloatingViewPresenter {
    private weak var view: FloatingViewPresenterOutput!
    private var model: FloatingViewModelInput
    
    // オプションをタップされたアイテム
    var optionTappedItem: ReadingItem!
    
    let notificationCenter = NotificationCenter.default
    
    init(view:  FloatingViewPresenterOutput, model: FloatingViewModelInput) {
        self.view = view
        self.model = model
        
        notificationCenter.addObserver(self, selector: #selector(deleteItem), name: .deleteFinishedItem, object: nil)
        notificationCenter.addObserver(self, selector: #selector(changeItemStateToReading), name: .changeItemStateToReading, object: nil)
        notificationCenter.addObserver(self, selector: #selector(fetchFinishedList), name: .updateFinishedList, object: nil)
    }
    
    @objc private func fetchFinishedList() {
        if let items = model.fetchFinishedItems() {
            if items.count == 0 {
                view.updateList(results: items)
                // view.displayNoContentView()
            } else {
                view.updateList(results: items)
                // view.dismissNoContentView()
            }
        } else {
            // view.displayNoContentView()
        }
    }
    
    /// 削除アクションされたアイテムを削除しリストを更新
    @objc private func deleteItem() {
        model.deleteItem(readingItem: optionTappedItem)
        fetchFinishedList()
        notificationCenter.post(name: .dismissItemOption, object: nil)
    }
    
    /// アイテムをリーディングリストに戻し更新
    @objc private func changeItemStateToReading() {
        model.changeItemStateToReading(item: optionTappedItem)
        // 既読リスト更新
        fetchFinishedList()
        // リーディングリスト更新
        notificationCenter.post(name: .updateReadingList, object: nil)
        notificationCenter.post(name: .dismissItemOption, object: nil)
    }
}

extension  FloatingViewPresenter: FloatingViewPresenterInput {
    func optionTapped(item: ReadingItem) {
        optionTappedItem = item
        view.displayFinishedListDialog(item: item)
    }
    
    func viewWillAppear() {
        fetchFinishedList()
    }
}
