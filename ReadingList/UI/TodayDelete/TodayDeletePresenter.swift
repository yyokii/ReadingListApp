//
//  TodayDeletePresenter.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/09/02.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol TodayDeletePresenterInput {}

protocol TodayDeletePresenterOutput: AnyObject {
}

final class TodayDeletePresenter {
    private weak var view: TodayDeletePresenterOutput!
    private var model: TodayDeleteModelInput
    
    init(view: TodayDeletePresenterOutput, model: TodayDeleteModelInput) {
        self.view = view
        self.model = model
    }
}

extension  TodayDeletePresenter: TodayDeletePresenterInput {}
