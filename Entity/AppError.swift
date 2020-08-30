//
//  AppError.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/06/29.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

enum AppError: Error {
    case other(Error?)
    case serverError(Error)
    case requestCouldNotBeBuilt
    case validationError(String)
}

extension AppError: LocalizedError {
    
    var message: String {
        switch self {
        case .serverError:
            return "申し訳ございません、通信に失敗しました"
        case .requestCouldNotBeBuilt:
            return "申し訳ございません、通信に失敗しました"
        case .other:
            return "不明なエラーが発生しました。時間をおいて再度ご利用ください。"
        case let .validationError(message):
            return message
        }
    }

    var localizedDescription: String {
        switch self {
        case let .serverError(error):
            return "\(error.localizedDescription)"
        case .requestCouldNotBeBuilt:
            return "リクエストが送れませんでした"
        case let .other(error):
            return error?.localizedDescription ?? "不明なエラー"
        case let .validationError(message):
            return message
        }
    }
}
