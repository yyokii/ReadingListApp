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

/// 保存している記事閲覧webviewのPresenter
/// 記事情報の更新い応じた下部ボタンの表示更新は未対応
final class ArticleWebPresenter {
    
    private weak var view: ArticleWebPresenterOutput!
    private weak var itemViewerUseCase:  ItemViewerUseCaseProtocol!

    var item: ReadingListItem!
    
    init(view: ArticleWebPresenterOutput, itemViewerUseCase: ItemViewerUseCaseProtocol) {
        
        self.view = view
        self.itemViewerUseCase = itemViewerUseCase
        self.itemViewerUseCase.output = self
    }
    
    private func updateActionBtnState() {
        if item.finishedReadingAt == nil {
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

extension  ArticleWebPresenter: ItemViewerUseCaseOutput {
    
    func didUpdateItemData(_ itemID: String) {

        if item.finishedReadingAt == nil {
            // 対象アイテムがリーディングリストにある場合
            view.showSuccessAddFinishedListDialog()
        } else {
            // 対象アイテムが既読リストなど、リーディングリストにはいっていない場合
            view.showSuccessAddReadingListDialog()
        }
    }
    
    func useCaseDidReceiveError(_ error: WebClientError) {
        // TODO:
    }
}

extension  ArticleWebPresenter: ArticleWebPresenterInput {
    
    func viewDidLoad() {
        let url = URL(string: item.url)!
        view.load(url: url)
        
        updateActionBtnState()
    }
    
    func tapItemActionButton() {
        
        if item.finishedReadingAt == nil {

            // リーディングリストのもの
            itemViewerUseCase.finishReadingItem(item)
            
        } else {
            
            // 既読リストなど、リーディングリストにはいっていないもの
            itemViewerUseCase.saveToReadingList(item)
        }
    }
}
