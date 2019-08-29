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
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var todayDataView: TodayDataView!
    @IBOutlet weak var finishedLineChartView: YomuLineChartView!
    @IBOutlet weak var listCountLbl: UILabel!
    @IBOutlet weak var finishedCountLbl: UILabel!
    
    private var presenter: HomePresenterInput!
    
    func inject(presenter: HomePresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()

        navigationItem.title = "Yomu"
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        baseScrollView.contentInset = adjustForTabbarInsets
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
}

extension HomeVC: HomePresenterOutput {
    func displayTutorialDialog() {
        SwiftMessageUtil.showCenteredIconMessage(iconImage: UIImage.init(named: "footer_icon")!, title: "ようこそ「Yomu」へ！", body: "ダウンロードありがとうございます☺️\n「Yomu」は通知の来る最新のリーディングリストアプリです。\n他のアプリから記事を「Yomu」へ追加し、「積ん読」をなくしましょう！\n\nこの画面では自分のデータを確認することができます！", buttonTitle: "OK")

    }
    
    func updateStatusLabel(text: String) {
        statusLbl.text = text
    }
    
    func updateGraph(datas: [Double]) {
        finishedLineChartView.drawLineChart(xValArr: ["1","2","3","4","5","6","7"], yValArr: datas)
    }
    
    func updateTodayDataView(addedCount: Int, expire1DayCount: Int, expire2DaysCount: Int) {
        todayDataView.configureView(addDataCount: addedCount, expire1DayCount: expire1DayCount, expire2DaysCount: expire2DaysCount)
    }
    
    func updateTotalData(listCount: Int, finishedCount: Int) {
        listCountLbl.text = "\(listCount)"
        finishedCountLbl.text = "\(finishedCount)"
    }
}
