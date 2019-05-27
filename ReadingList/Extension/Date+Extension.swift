//
//  Date+Extension.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/05/12.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

extension Date {
    /// フォーマッターを作成
    func getFormatter(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .short) -> DateFormatter {
        let formater = DateFormatter()
        formater.dateStyle = dateStyle
        formater.timeStyle = timeStyle
        return formater
    }
}
