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
    func hideToolBar()
    func showToolBar()
    func showAddReadinListBtn()
    func showAddFinishedListBtn()
    func showSuccessAddReadingListDialog()
    func showSuccessAddFinishedListDialog()
}

final class ArticleWebPresenter {
    
    var item: ReadingListItem!
    
    private weak var view: ArticleWebPresenterOutput!
    private var model: ArticleWebModelInput
    
    init(view: ArticleWebPresenterOutput, model: ArticleWebModelInput) {
        self.view = view
        self.model = model
    }
    
    private func updateActionBtnState() {
        if item.finishedReadingDate == nil {
            // リーディングリストにあるもの
            view.showAddFinishedListBtn()
        } else {
            // 既読リストなど、リーディングリストにはいっていないもの
            view.showAddReadinListBtn()
        }
    }
    
    private func configureToobBar() {
        if item.isDeleted {
            view.hideToolBar()
        } else {
            view.showToolBar()
        }
    }
}

extension  ArticleWebPresenter: ArticleWebPresenterInput {
    
    func viewDidLoad() {
        let url = URL(string: item.url)!
        view.load(url: url)
        
        updateActionBtnState()
    }
    
    func tapItemActionButton() {
        
        if item.finishedReadingDate == nil {
            // リーディングリストのもの
            
            // TODO: fix
            // model.addItemToFinishedList(item: item)
            
            view.showSuccessAddFinishedListDialog()
            // view.showAddReadinListBtn()
            
        } else {
            // 既読リストなど、リーディングリストにはいっていないもの
            
            // TODO: fix
            // model.addItemToReadingList(item: item)
            
            view.showSuccessAddReadingListDialog()
            // view.showAddFinishedListBtn()
        }
        
        updateActionBtnState()
    }
}
