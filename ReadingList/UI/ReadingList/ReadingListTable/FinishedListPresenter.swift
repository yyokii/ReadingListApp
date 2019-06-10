//
//  FinishedListPresenter.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/06/09.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol FinishedListPresenterInput {
    func viewWillAppear()
}

protocol  FinishedListPresenterOutput: AnyObject {
    func updateList(results: Results<ReadingItem>)
}

final class  FinishedListPresenter {
    private weak var view: FinishedListPresenterOutput!
    private var model: ListModelInput
    let center = NotificationCenter.default
    
    init(view:  FinishedListPresenterOutput, model: ListModelInput ) {
        self.view = view
        self.model = model
    }
    
    private func fetchFinishedList() {
        if let items = RealmManager.sharedInstance.readFinishedItems() {
            view.updateList(results: items)
        }
    }
}

extension  FinishedListPresenter:  FinishedListPresenterInput {
    func viewWillAppear() {
        fetchFinishedList()
    }
}

