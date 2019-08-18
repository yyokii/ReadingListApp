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
    func viewWillAppear()
}

protocol  HomePresenterOutput: AnyObject {
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
    func viewWillAppear() {
        
        view.updateGraph(datas: model.fetchFinishedGraphData())
        view.updateTodayDataView(addedCount: model.fetchTodayAddCount(), expire1DayCount: model.expire1DayCount(), expire2DaysCount: model.expire2DaysCount())
        view.updateTotalData(listCount: model.fetchReadingListCount(), finishedCount: model.fetchFinishedListCount())
    }
}
