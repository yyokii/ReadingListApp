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
    func displayUserData(dataViewModel: GraphViewModel)
    func displayTodayDeleteList()
    func displayReadingList()
}

final class  HomePresenter {
    private weak var view: HomePresenterOutput!
    private var model: HomeModelInput
    
    init(view:  HomePresenterOutput, model: HomeModelInput) {
        self.view = view
        self.model = model
    }
    
    private func fetchUserData() {
        let one = model.expireOneDayCount()
        let two = model.expireTwoDaysCount()
        let three = model.expireThreeDaysCount()
        let four = model.expireFourDaysCount()
        let five = model.expireFiveDaysCount()
        let six = model.expireSixDaysCount()
        let seven = model.expireSevenDaysCount()
        
        let dataViewModel = GraphViewModel(oneDayAfterCount: one, twoDaysAfterCount: two, threeDaysAfterCount: three, fourDaysAfterCount: four, fiveDaysAfterCount: five, sixDaysAfterCount: six, sevenDaysAfterCount: seven)
        
        view.displayUserData(dataViewModel: dataViewModel)
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
        fetchUserData()
    }
}
