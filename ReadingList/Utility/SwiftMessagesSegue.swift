//
//  SwiftMessagesSegue.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/06/09.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import SwiftMessages

/// SwiftMessagesのカスタムセグエクラス
class SwiftMessagesBottomTabSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .bottomTab)
        // 表示するVCのサイズ指定　（ https://github.com/SwiftKickMobile/SwiftMessages/blob/master/ViewControllers.md ）
        messageView.backgroundHeight = 300
    }
}
