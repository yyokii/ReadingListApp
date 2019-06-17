//
//  SwiftMessageUtil.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/06/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import SwiftMessages

struct SwiftMessageUtil {
    
    static func showMessage(title: String, message: String) {
        // view
        let view: MessageView
        view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
        let iconText = "👍"
        view.configureTheme(backgroundColor: UIColor.green, foregroundColor: UIColor.white, iconImage: nil, iconText: iconText)
        view.configureDropShadow()
        
        // config
        var config = SwiftMessages.defaultConfig
        config.interactiveHide = true
        view.button?.isHidden = true

        SwiftMessages.show(config: config, view: view)
    }
}
