//
//  ValidateString.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/30.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

enum ValidateString: String {
    case email = ".+@.+"
    case password = "^([a-zA-Z0-9]{8,})$"
}
