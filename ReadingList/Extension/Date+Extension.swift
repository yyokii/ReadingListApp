//
//  Date+Extension.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/05/12.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

extension Date {
    /// フォーマットされた今日の日付
    func formattedToday() -> String {
        let formater = DateFormatter()
        formater.dateStyle = .medium
        formater.timeStyle = .short
        return formater.string(from: Date())
    }
}
