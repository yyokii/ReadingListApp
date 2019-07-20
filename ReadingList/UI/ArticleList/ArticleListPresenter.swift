//
//  ArticleListPresenter.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/06/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol ArticleListPresenterInput {
    func viewDidload()
    func addReadingList(article: Article)
}

protocol  ArticleListPresenterOutput: AnyObject {
    func dismissIndicator()
    func showSuccessAddDialog()
    func showIndicator()
    func updateList(results: [Article])
}

final class  ArticleListPresenter {
    private weak var view: ArticleListPresenterOutput!
    private var model: ArticleListModelInput
    let center = NotificationCenter.default
    
    init(view:  ArticleListPresenterOutput, model: ArticleListModelInput) {
        self.view = view
        self.model = model
    }
    
    private func fetchArticles() {
        view.showIndicator()
        FirebaseManager.sharedInstance.fetchArticles {[weak self] articles in
            self?.view.dismissIndicator()
            self?.view.updateList(results: articles)
        }
    }
}

extension  ArticleListPresenter:  ArticleListPresenterInput {
    func viewDidload() {
        fetchArticles()
    }
    
    func addReadingList(article: Article) {
        model.addItemToRealm(from: article)
        view.showSuccessAddDialog()
    }
}
