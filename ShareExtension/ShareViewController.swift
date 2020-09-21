//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by 東原与生 on 2020/08/09.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Yomu🔥"
        
        // ナビゲーションのデザイン
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(named: Constant.Color.greenSheen)
        
        let controller: UIViewController = self.navigationController!.viewControllers.first!
        controller.navigationItem.rightBarButtonItem!.title = "保存👜"
        controller.navigationItem.leftBarButtonItem!.title = "戻る⏪"
        
    }
    
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
                    // 一週間後の日付（=読み終わり予定の期限日）を取得
                    let calendar = Calendar.current
                    let dueDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: now)
                    guard let due = dueDate else { return }
                    
                    // 保存
                    var itemDic = Dictionary<String, Any>()
                    itemDic = [Constant.ReadingItem.title : title, Constant.ReadingItem.url: itemUrl, Constant.ReadingItem.createdAt: now, Constant.ReadingItem.dueDate: due]
                    
                    // TODO: 書き換える
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

