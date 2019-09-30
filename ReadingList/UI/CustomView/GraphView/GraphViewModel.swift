//
//  GraphViewModel.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/31.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import RealmSwift

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
    
    init(items: Results<ReadingItem>) {
        
        let now = Date()
        
        let firstItemsCount = items.filter({
            $0.differenceDay(fromDate: now) <= 1
        }).count
        
        let secondItemsCount = items.filter({
            $0.differenceDay(fromDate: now) == 2
        }).count
        
        let thirdItemsCount = items.filter({
            $0.differenceDay(fromDate: now) == 3
        }).count
        
        let fourthItemsCount = items.filter({
            $0.differenceDay(fromDate: now) == 4
        }).count
        
        let fifthItemsCount = items.filter({
            $0.differenceDay(fromDate: now) == 5
        }).count
        
        let sixthItemsCount = items.filter({
            $0.differenceDay(fromDate: now) == 6
        }).count
        
        let seventhItemsCount = items.filter({
            $0.differenceDay(fromDate: now) == 7
        }).count
        
        totalCount = firstItemsCount + secondItemsCount + thirdItemsCount + fourthItemsCount + fifthItemsCount + sixthItemsCount + seventhItemsCount
        
        let firstHeight: CGFloat = ( firstItemsCount == 0 ) ? noDataHeight : min(CGFloat(firstItemsCount) / 10.0 * barMaxHeight, barMaxHeight)
        firstBarHeight = firstHeight
        
        let secondHeight: CGFloat = ( secondItemsCount == 0 ) ? noDataHeight : min(CGFloat(secondItemsCount) / 10.0 * barMaxHeight, barMaxHeight)
        secondBarHeight = secondHeight
        
        let thirdHeight: CGFloat = ( thirdItemsCount == 0 ) ? noDataHeight : min(CGFloat(thirdItemsCount) / 10.0 * barMaxHeight, barMaxHeight)
        thirdBarHeight = thirdHeight
        
        let fourthHeight: CGFloat = ( fourthItemsCount == 0 ) ? noDataHeight : min(CGFloat(fourthItemsCount) / 10.0 * barMaxHeight, barMaxHeight)
        fourthBarHeight = fourthHeight
        
        let fifthHeight: CGFloat = ( fifthItemsCount == 0 ) ? noDataHeight : min(CGFloat(fifthItemsCount) / 10.0 * barMaxHeight, barMaxHeight)
        fifthBarHeight = fifthHeight
        
        let sixthHeight: CGFloat = ( sixthItemsCount == 0 ) ? noDataHeight : min(CGFloat(sixthItemsCount) / 10.0 * barMaxHeight, barMaxHeight)
        sixthBarHeight = sixthHeight
        
        let seventhHeight: CGFloat = ( seventhItemsCount == 0 ) ? noDataHeight : min(CGFloat(seventhItemsCount) / 10.0 * barMaxHeight, barMaxHeight)
        seventhBarHeight = seventhHeight
        
    }
}
