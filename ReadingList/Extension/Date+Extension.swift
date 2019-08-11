//
//  Date+Extension.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/05/12.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

extension Date {
    /// dateのstart日時を取得
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// dateのend日時を取得
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    /// フォーマッターを作成
    static func getFormatter(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .short) -> DateFormatter {
        let formater = DateFormatter()
        formater.dateStyle = dateStyle
        formater.timeStyle = timeStyle
        return formater
    }
    
    /// 数日後（引き数日後）の日付を取得する
    static func getDueDate(addingDaysValue: Int) -> Date? {
        // 今日の終わりのDateを取得
        let todayEndDate = endOfDayForDate(date: Date())
        guard let endDate = todayEndDate else { return nil }
        
        // 期限の日付を取得
        let calendar = Calendar.current
        let dateByAdding = calendar.date(byAdding: .day, value: addingDaysValue, to: endDate)
        guard let dueDate = dateByAdding else { return nil }
        
        // 期限の日付をフォーマッターで加工しdate型で作成
        let formatter = Date.getFormatter()
        let formattedString = formatter.string(from: dueDate)
        let formattedDate = formatter.date(from: formattedString)
        guard let date = formattedDate else { return nil }
        return date
    }

    /// 特定のdateの最終時を取得
    static func endOfDayForDate(date: Date) -> Date? {
        let cal = Calendar.current
        var components = DateComponents()
        components.day = 1
        let addedOneDayDate = cal.date(byAdding: components, to: cal.startOfDay(for: date))
        let endDate = addedOneDayDate?.addingTimeInterval(-1)
        return endDate
    }
}
