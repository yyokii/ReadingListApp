//
//  SwiftMessageUtil.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/06/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
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
        view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "", buttonTapHandler: { _ in SwiftMessages.hide() })
        view.configureDropShadow()
        
        // タイプに基づきテーマ設定
        switch type {
        case .Delete:
            view.configureTheme(backgroundColor: UIColor.green, foregroundColor: UIColor.white, iconImage: nil, iconText: iconText)
        case .Fail:
            view.configureTheme(backgroundColor: UIColor.green, foregroundColor: UIColor.white, iconImage: nil, iconText: iconText)
        case .Success:
            view.configureTheme(backgroundColor: UIColor.init(named: Constant.Color.greenSheen)!, foregroundColor: UIColor.white, iconImage: nil, iconText: iconText)
        case .ToFinishedList:
            view.configureTheme(backgroundColor: UIColor.init(named: Constant.Color.cornFlower)!, foregroundColor: UIColor.white, iconImage: nil, iconText: iconText)
        case .ToReadingList:
            view.configureTheme(backgroundColor: UIColor.init(named: Constant.Color.cornFlower)!, foregroundColor: UIColor.white, iconImage: nil, iconText: iconText)
        }
        
        // config
        var config = SwiftMessages.defaultConfig
        config.interactiveHide = true
        view.button?.isHidden = true

        SwiftMessages.show(config: config, view: view)
    }
    
    /// センター表示の画像付きダイアログ
    static func showCenteredIconMessage(iconImage: UIImage, title: String, body: String, buttonTitle: String) {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 300)
        messageView.configureContent(title: title, body: body, iconImage: iconImage, iconText: "", buttonImage: nil, buttonTitle: buttonTitle) { _ in
            SwiftMessages.hide()
        }
                
        messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .gray(interactive: false)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: messageView)
    }
    
    /// 未読記事（リーディングリスト）にてオプションダイアログを表示
    static func showReadingListDialog(title: String) {
        let view: ReadingItemDialogView = try! SwiftMessages.viewFromNib()
        view.title = title
        view.configureDropShadow()
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
    
    /// 既読記事にてオプションダイアログを表示
    static func showFinishedListDialog(title: String) {
        let view: FinishedItemDialogView = try! SwiftMessages.viewFromNib()
        view.title = title
        view.configureDropShadow()
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
    
    /// 既読記事にてオプションダイアログを表示
    static func showTutorialDialog() {
        let view: TutorialDialogView = try! SwiftMessages.viewFromNib()
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
    
//    static func showWebHowtoView() {
//        let howtoView = WebHowtoView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 300))
//        let messageView = BaseView(frame: .zero)
//        messageView.layoutMargins = .zero
//        messageView.backgroundHeight = 300.0
//        do {
//            let backgroundView = CornerRoundingView()
//            backgroundView.layer.cornerRadius = 15
//            backgroundView.layer.masksToBounds = true
//            messageView.installBackgroundView(backgroundView)
//            messageView.installContentView(howtoView)
//            messageView.layoutMarginAdditions = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
//        }
//        messageView.configureDropShadow()
//        var config = SwiftMessages.defaultConfig
//        config.presentationStyle = .center
//        config.duration = .forever
//        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
//        SwiftMessages.show(config: config, view: messageView)
//    }

}
