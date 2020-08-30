//
//  Validator.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/31.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

struct Validator {
    static func validatedText(text: String, validationType: ValidatorType) throws -> String {
        let validator = ValidatorFactory.validatorFor(type: validationType)
        return try validator.validated(text)
    }
}
