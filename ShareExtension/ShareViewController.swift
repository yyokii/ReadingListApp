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
                    
                    let now = Date()
                    // 日付取得
                    let formatter = Date().getFormatter()
                    let dateString = formatter.string(from: now)
                    
                    // 一週間後の日付（=読み終わり予定の期限日）を取得
                    let calendar = Calendar.current
                    let dueDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: now)
                    guard let due = dueDate else { return }
                    let dueDateString = formatter.string(from: due)
                    
                    // 保存
                    var itemDic = Dictionary<String, String>()
                    itemDic = [Constant.ReadingItem.title : title, Constant.ReadingItem.url: itemUrl, Constant.ReadingItem.createdDate: dateString, Constant.ReadingItem.dueDate: dueDateString, Constant.ReadingItem.finishedDate: ""]
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
