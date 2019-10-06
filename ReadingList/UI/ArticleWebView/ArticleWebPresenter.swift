//
//  ArticleWebPresenter.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/10/01.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

protocol ArticleWebPresenterInput {
    func tapItemActionButton()
    func viewDidLoad()
}

protocol ArticleWebPresenterOutput: AnyObject {
    func closeView()
    func load(url: URL)
    func showAddReadinListBtn()
    func showAddFinishedListBtn()
    func showSuccessAddReadingListDialog()
    func showSuccessAddFinishedListDialog()
    func updateActionBtnState()
}

final class ArticleWebPresenter {
    
    var item: ReadingItem!
    
    private weak var view: ArticleWebPresenterOutput!
    private var model: ArticleWebModelInput
    
    init(view: ArticleWebPresenterOutput, model: ArticleWebModelInput) {
        self.view = view
        self.model = model
    }
}

extension  ArticleWebPresenter: ArticleWebPresenterInput {
    
    func viewDidLoad() {
        let url = URL(string: item.url)!
        view.load(url: url)
    }
    
    func tapItemActionButton() {
        
        if item.finishedDate == nil {
            // リーディングリストのもの
            model.addItemToFinishedList(item: item)
            view.showSuccessAddFinishedListDialog()
            view.showAddReadinListBtn()
            
        } else {
            // 既読など、リーディングリストにはいっていないもの
            model.addItemToReadingList(item: item)
            view.showSuccessAddReadingListDialog()
            view.showAddFinishedListBtn()
        }
    }
}
