//
//  FloatingViewPresenter.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/09/01.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol FloatingViewPresenterInput: AnyObject {
    func tapOptionBtn(item: ReadingListItem)
    func tapMoveItemToReadingList()
    func tapDeleteItem()
    func viewWillAppear()
}

protocol FloatingViewPresenterOutput: AnyObject {
    func updateFinishedList(items: [ReadingListItem])
    func updateList()
    func displayNoContentView()
    func dismissNoContentView()
}

final class  FloatingViewPresenter {
    
    private weak var view: FloatingViewPresenterOutput!
    private weak var readingListUseCase:  ReadingListUseCaseProtocol!
    
    // オプションをタップされたアイテム
    var optionTappedItem: ReadingListItem!
    
    let notificationCenter = NotificationCenter.default
    
    init(view:  FloatingViewPresenterOutput, readingListUseCase: ReadingListUseCaseProtocol) {
        
        self.view = view
        self.readingListUseCase = readingListUseCase
    }
}

extension  FloatingViewPresenter: FloatingViewPresenterInput {
    
    func tapMoveItemToReadingList() {
        guard let item = optionTappedItem else {
            return
        }
        readingListUseCase.saveToReadingList(item)
    }
    
    func tapDeleteItem() {
        guard let item = optionTappedItem else {
            return
        }
        readingListUseCase.deleteReadingItem(item)
    }
    
    func tapOptionBtn(item: ReadingListItem) {
        optionTappedItem = item
    }
    
    func viewWillAppear() {}
}
