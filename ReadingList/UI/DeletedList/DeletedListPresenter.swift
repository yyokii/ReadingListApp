//
//  DeletedListPresenter.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/10/07.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol DeletedListPresenterInput {
    func viewWillAppear()
}

protocol DeletedListPresenterOutput: AnyObject {
    func updateDeletedList(items: [ReadingListItem])
}

final class  DeletedListPresenter {
    private weak var view: DeletedListPresenterOutput!
    private var model: DeletedListModelInput
    
    let notificationCenter = NotificationCenter.default
    
    private var optionTappedItem: ReadingItem!
    
    private var notFinishedItems: Results<ReadingItem>?
    
    init(view:  DeletedListPresenterOutput, model: DeletedListModelInput) {
        self.view = view
        self.model = model
    }
}

extension  DeletedListPresenter: DeletedListPresenterInput {
    func viewWillAppear() {
        view.updateDeletedList(items: model.fetchDeletedItems().reversed())
    }
}
