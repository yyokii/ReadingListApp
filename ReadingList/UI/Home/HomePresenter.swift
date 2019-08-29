//
//  HomePresenter.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol HomePresenterInput {
    func viewDidLoad()
    func viewWillAppear()
}

protocol  HomePresenterOutput: AnyObject {
    func displayTutorialDialog()
    func updateStatusLabel(text: String)
    func updateGraph(datas: [Double])
    func updateTodayDataView(addedCount: Int, expire1DayCount: Int, expire2DaysCount: Int)
    func updateTotalData(listCount: Int, finishedCount: Int)
}

final class  HomePresenter {
    private weak var view: HomePresenterOutput!
    private var model: HomeModelInput
    
    init(view:  HomePresenterOutput, model: HomeModelInput) {
        self.view = view
        self.model = model
    }
}

extension  HomePresenter: HomePresenterInput {
    func viewDidLoad() {
        if UserDefaultManager.shareInstance.isFirstOpenArticleView() {
            view.displayTutorialDialog()
            UserDefaultManager.shareInstance.setFirstOpenArticleView()
        }
    }
    
    func viewWillAppear() {
        
        let expire1DayCount = model.expire1DayCount()
        let expire2DaysCount = model.expire2DaysCount()
        
        if ((expire1DayCount == 0) && (expire2DaysCount == 0)) {
            view.updateStatusLabel(text: "😄 現在「積ん読」はありません ")
        } else {
            view.updateStatusLabel(text: "🙄 おっと積ん読しているものがあります！ ")
        }
        
        view.updateTodayDataView(addedCount: model.fetchTodayAddCount(), expire1DayCount: expire1DayCount, expire2DaysCount: expire2DaysCount)
        
        view.updateGraph(datas: model.fetchFinishedGraphData())
        view.updateTotalData(listCount: model.fetchReadingListCount(), finishedCount: model.fetchFinishedListCount())
    }
}
