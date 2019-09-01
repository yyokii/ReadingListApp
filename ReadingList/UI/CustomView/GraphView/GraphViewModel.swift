//
//  GraphViewModel.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/31.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit

/// データ画面で表示するデータ
struct GraphViewModel {
    let totalCount: Int
    
    let firstBarHeight: CGFloat
    let secondBarHeight: CGFloat
    let thirdBarHeight: CGFloat
    let fourthBarHeight: CGFloat
    let fifthBarHeight: CGFloat
    let sixthBarHeight: CGFloat
    let seventhBarHeight: CGFloat
    
    let noDataHeight: CGFloat = 15
    let barMaxHeight: CGFloat = 180
    
    init(oneDayAfterCount: Int, twoDaysAfterCount: Int, threeDaysAfterCount: Int, fourDaysAfterCount: Int, fiveDaysAfterCount: Int, sixDaysAfterCount: Int, sevenDaysAfterCount: Int) {
        
        totalCount = oneDayAfterCount + twoDaysAfterCount + threeDaysAfterCount + fourDaysAfterCount + fiveDaysAfterCount + sixDaysAfterCount + sevenDaysAfterCount
        
        let firstHeight: CGFloat = ( oneDayAfterCount == 0 ) ? noDataHeight : min(CGFloat(oneDayAfterCount) / 10.0 * barMaxHeight, barMaxHeight)
        firstBarHeight = firstHeight
        
        let secondHeight: CGFloat = ( twoDaysAfterCount == 0 ) ? noDataHeight : min(CGFloat(twoDaysAfterCount) / 10.0 * barMaxHeight, barMaxHeight)
        secondBarHeight = secondHeight
        
        let thirdHeight: CGFloat = ( threeDaysAfterCount == 0 ) ? noDataHeight : min(CGFloat(threeDaysAfterCount) / 10.0 * barMaxHeight, barMaxHeight)
        thirdBarHeight = thirdHeight
        
        let fourthHeight: CGFloat = ( fourDaysAfterCount == 0 ) ? noDataHeight : min(CGFloat(fourDaysAfterCount) / 10.0 * barMaxHeight, barMaxHeight)
        fourthBarHeight = fourthHeight
        
        let fifthHeight: CGFloat = ( fiveDaysAfterCount == 0 ) ? noDataHeight : min(CGFloat(fiveDaysAfterCount) / 10.0 * barMaxHeight, barMaxHeight)
        fifthBarHeight = fifthHeight
        
        let sixthHeight: CGFloat = ( sixDaysAfterCount == 0 ) ? noDataHeight : min(CGFloat(sixDaysAfterCount) / 10.0 * barMaxHeight, barMaxHeight)
        sixthBarHeight = sixthHeight
        
        let seventhHeight: CGFloat = ( sevenDaysAfterCount == 0 ) ? noDataHeight : min(CGFloat(sevenDaysAfterCount) / 10.0 * barMaxHeight, barMaxHeight)
        seventhBarHeight = seventhHeight
        
    }
}
