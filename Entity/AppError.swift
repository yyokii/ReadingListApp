//
//  AppError.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/06/29.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

enum WebClientError: Error {
    case other(Error?)
    case serverError(Error)
    case requestCouldNotBeBuilt
}

extension WebClientError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case let .serverError(error):
            return "エラー: \(error.localizedDescription)"
        case .requestCouldNotBeBuilt:
            return "リクエストが送れませんでした"
        case let .other(error):
            return error?.localizedDescription ?? "不明なエラー"
        }
    }
}
