//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Yoki Higashihara on 2019/04/14.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        let extensionItem: NSExtensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = (extensionItem.attachments?.first)!
        
        let puclicURL = String(kUTTypeURL)
        if itemProvider.hasItemConformingToTypeIdentifier(puclicURL) {
            itemProvider.loadItem(forTypeIdentifier: puclicURL, options: nil, completionHandler: { [weak self] (item, error) in
                // NSURLを取得
                if let url = item as? NSURL {
                    guard let itemUrl = url.absoluteString, let title = self?.contentText else {
                        return
                    }
                    // 日付取得
                    let dateString = Date().formattedToday()
                    
                    var itemDic = Dictionary<String, String>()
                    itemDic = [Constant.readingItem.title : title, Constant.readingItem.url: itemUrl, Constant.readingItem.createdDate: dateString, Constant.readingItem.finishedDate: ""]
                    UserDefaultManager.shareInstance.addReadingItem(readingItem: itemDic)
                }
                self?.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            })
        }
    }

    // 追加項目の設定
    override func configurationItems() -> [Any]! {
        return []
    }
}
