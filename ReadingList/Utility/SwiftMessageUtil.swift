//
//  SwiftMessageUtil.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/06/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import SwiftMessages

enum DialogType {
    case Delete
    case Fail
    case Success
    case ToFinishedList
    case ToReadingList
}

struct SwiftMessageUtil {
    
    /// 上から表示するテキストアイコンを使用したダイアログ
    static func showIconTextMessage(type: DialogType, iconText: String, title: String, message: String) {
        // view
        let view: MessageView
        view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
        view.configureDropShadow()
        
        // タイプに基づきテーマ設定
        switch type {
        case .Delete:
            view.configureTheme(backgroundColor: UIColor.green, foregroundColor: UIColor.white, iconImage: nil, iconText: iconText)
        case .Fail:
            view.configureTheme(backgroundColor: UIColor.green, foregroundColor: UIColor.white, iconImage: nil, iconText: iconText)
        case .Success:
            view.configureTheme(backgroundColor: UIColor.green, foregroundColor: UIColor.white, iconImage: nil, iconText: iconText)
        case .ToFinishedList:
            view.configureTheme(backgroundColor: UIColor.green, foregroundColor: UIColor.white, iconImage: nil, iconText: iconText)
        case .ToReadingList:
            view.configureTheme(backgroundColor: UIColor.green, foregroundColor: UIColor.white, iconImage: nil, iconText: iconText)
        }
        
        
        // config
        var config = SwiftMessages.defaultConfig
        config.interactiveHide = true
        view.button?.isHidden = true

        SwiftMessages.show(config: config, view: view)
    }
    
    static func showCenteredMessage(iconText: String, title: String, body: String, buttonTitle: String) {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 300)
        messageView.configureContent(title: title, body: body, iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: buttonTitle) { _ in
            SwiftMessages.hide()
        }
        messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: messageView)
    }
}
