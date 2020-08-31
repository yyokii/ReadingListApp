//
//  Validators.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/30.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

enum ValidatorType {
    case email
    case password
}

final class ValidatorFactory {
    
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .email: return EmailValidator()
        case .password: return PasswordValidator()
        }
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}

struct EmailValidator: ValidatorConvertible {

    func validated(_ value: String) throws -> String {
        
        do {
            if try NSRegularExpression(pattern: ValidateString.email.rawValue, options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw AppError.validationError("メールアドレスが正しくないようです")
            }
        } catch {
            throw AppError.validationError("メールアドレスが正しくないようです")
        }
        return value
    }
}

struct PasswordValidator: ValidatorConvertible {

    func validated(_ value: String) throws -> String {
        
        do {
            if try NSRegularExpression(pattern: ValidateString.password.rawValue, options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw AppError.validationError("パスワードは英数字の8文字以上です")
            }
        } catch {
            throw AppError.validationError("パスワードは英数字の8文字以上です")
        }
        return value
    }
}
