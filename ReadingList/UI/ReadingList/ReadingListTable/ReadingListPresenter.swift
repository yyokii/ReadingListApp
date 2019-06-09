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
    func deleteItem(readingItem: ReadingItem)
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
    let center = NotificationCenter.default
    
    init(view: ReadingListPresenterOutput, model: ListModelInput ) {
        self.view = view
        self.model = model
    }
    
    private func addObserver() {
        center.addObserver(self, selector: #selector(viewWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
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
}

extension ReadingListPresenter: ReadingListPresenterInput {
    func deleteItem(readingItem: ReadingItem) {
        model.deleteItem(readingItem: readingItem)
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
