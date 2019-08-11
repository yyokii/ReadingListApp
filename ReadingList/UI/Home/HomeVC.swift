//
//  HomeVC.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import Charts

class HomeVC: UIViewController {
    @IBOutlet weak var todayDataView: TodayDataView!
    @IBOutlet weak var finishedLineChartView: YomuLineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finishedLineChartView.drawLineChart(xValArr: ["0","0","0","0","0","0","0"], yValArr: [1,2,4,6,2,7,8])
    }
}

extension HomeVC: HomePresenterOutput {
    func updateTodayDataView(addedCount: Int, expire1DayCount: Int, expire2DaysCount: Int) {
        todayDataView.configureView(addDataCount: addedCount, expire1DayCount: expire1DayCount, expire2DaysCount: expire2DaysCount)
    }
}
