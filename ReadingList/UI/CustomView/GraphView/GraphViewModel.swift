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
    let firstItemsCount: Int
    
    let secondBarHeight: CGFloat
    let secondItemsCount: Int
    
    let thirdBarHeight: CGFloat
    let thirdItemsCount: Int
    
    let fourthBarHeight: CGFloat
    let fourthItemsCount: Int
    
    let fifthBarHeight: CGFloat
    let fifthItemsCount: Int
    
    let sixthBarHeight: CGFloat
    let sixthItemsCount: Int
    
    let seventhBarHeight: CGFloat
    let seventhItemsCount: Int
    
    let noDataHeight: CGFloat = 15
    let barMaxHeight: CGFloat = 180
    
    init(items: [ReadingListItem]) {
        
        let now = Date()
        
        firstItemsCount = items.filter({
            $0.differenceDay(fromDate: now) <= 1
        }).count
        
        secondItemsCount = items.filter({
            $0.differenceDay(fromDate: now) == 2
        }).count
        
        thirdItemsCount = items.filter({
            $0.differenceDay(fromDate: now) == 3
        }).count
        
        fourthItemsCount = items.filter({
            $0.differenceDay(fromDate: now) == 4
        }).count
        
        fifthItemsCount = items.filter({
            $0.differenceDay(fromDate: now) == 5
        }).count
        
        sixthItemsCount = items.filter({
            $0.differenceDay(fromDate: now) == 6
        }).count
        
        seventhItemsCount = items.filter({
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
