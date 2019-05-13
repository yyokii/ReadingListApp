//
//  ListPresenter.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/14.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import UIKit.UIApplication
import RealmSwift

protocol ListPresenterInput {
    func viewDidLoad()
    func viewWillAppear()
    func didTapAddButton()
    func deleteItem(readingItem: ReadingItem)
}

protocol ListPresenterOutput: AnyObject {
    func updateList(results: Results<ReadingItem>)
}

final class ListPresenter {
    private weak var view: ListPresenterOutput!
    private var model: ListModelInput
    let center = NotificationCenter.default
    
    init(view: ListPresenterOutput, model: ListModelInput ) {
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
            // UI更新
            if let items = RealmManager.sharedInstance.readNotFinishedItems() {
                view.updateList(results: items)
            }
        }
    }
    
    /// シェアしたものを確認して保存
    private func addReadingItem() -> Bool {
        if let items = UserDefaultManager.shareInstance.fetchReadingItems() {
            model.addItemToRealm(from: items)
            return true
        }
        return false
    }
}

extension ListPresenter: ListPresenterInput {
    func viewDidLoad() {
        addObserver()
    }
    
    func viewWillAppear() {
        fetchAndUpdateList()
    }
    
    func didTapAddButton() {
        // TODO: ダイアログの表示
    }
    
    func deleteItem(readingItem: ReadingItem) {
        model.deleteItem(readingItem: readingItem)
    }
}
