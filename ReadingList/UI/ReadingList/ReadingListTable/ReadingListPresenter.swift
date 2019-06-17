//
//  ReadingListPresenter.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/06/09.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import UIKit.UIApplication
import RealmSwift

protocol ReadingListPresenterInput {
    func optionTapped(item: ReadingItem)
    func tapAddButton()
    func viewDidLoad()
    func viewWillAppear()
}

protocol ReadingListPresenterOutput: AnyObject {
    func updateList(results: Results<ReadingItem>)
}

final class ReadingListPresenter {
    private weak var view: ReadingListPresenterOutput!
    private var model: ListModelInput
    
    // オプションをタップされたアイテム
    var optionTappedItem: ReadingItem!
    let notificationCenter = NotificationCenter.default
    
    init(view: ReadingListPresenterOutput, model: ListModelInput ) {
        self.view = view
        self.model = model
        
        addObserver()
    }
    
    private func addObserver() {
        // TODO: バックグラウンドから復帰した時にデータを最新にするために必要かも
//        notificationCenter.addObserver(self, selector: #selector(viewWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(changeItemStateToFinished), name: .changeItemStateToFinishedReading, object: nil)
        notificationCenter.addObserver(self, selector: #selector(deleteItem), name: .deleteReadingItem, object: nil)
    }
    
    @objc func viewWillEnterForeground(_ notification: Notification?) {
        fetchAndUpdateList()
    }
    
    private func fetchAndUpdateList() {
        // 記事情報更新
        if addReadingItem() {
            // Userdefaultに保存している記事情報を削除
            UserDefaultManager.shareInstance.deleteReadingItems()
        }
        
        // UI更新
        if let items = RealmManager.sharedInstance.readNotFinishedItems() {
            view.updateList(results: items)
        }
    }
    
    /// シェアしたものを確認してRealmに保存
    private func addReadingItem() -> Bool {
        if let items = UserDefaultManager.shareInstance.fetchReadingItems() {
            model.addItemToRealm(from: items)
            return true
        }
        return false
    }
    
    /// 削除アクションされたアイテムを削除しリストを更新
    @objc func deleteItem() {
        model.deleteItem(readingItem: optionTappedItem)
        fetchAndUpdateList()
        notificationCenter.post(name: .dismissItemOption, object: nil)
    }
    
    /// アイテムを既読にし更新
    @objc private func changeItemStateToFinished() {
        model.changeItemStateToFinished(item: optionTappedItem)
        fetchAndUpdateList()
        notificationCenter.post(name: .dismissItemOption, object: nil)
    }
}

extension ReadingListPresenter: ReadingListPresenterInput {
    func optionTapped(item: ReadingItem) {
        optionTappedItem = item
    }
    
    func tapAddButton() {
        // TODO: ダイアログの表示
    }
    
    func viewDidLoad() {
        addObserver()
    }
    
    func viewWillAppear() {
        fetchAndUpdateList()
    }
}
