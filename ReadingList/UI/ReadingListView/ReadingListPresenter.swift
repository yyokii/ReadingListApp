//
//  ReadingListPresenter.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/09/07.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol ReadingListPresenterInput {
    func viewWillAppear()
}

protocol ReadingListPresenterOutput: AnyObject {
    func updateReadingList(items: [ReadingListItem])
}

final class ReadingListPresenter {
    private weak var view: ReadingListPresenterOutput!
    private var model: ReadingListModelInput
    
    init(view: ReadingListPresenterOutput, model: ReadingListModelInput) {
        self.view = view
        self.model = model
    }
    
    private func updateTodayDeleteList() {
        let items = model.fetchReadingItems()
        view.updateReadingList(items: items)
    }
}

extension  ReadingListPresenter: ReadingListPresenterInput {
    func viewWillAppear() {
        updateTodayDeleteList()
    }
}
