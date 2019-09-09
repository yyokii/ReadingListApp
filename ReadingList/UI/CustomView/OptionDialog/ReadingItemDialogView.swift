//
//  ReadingItemDialogView.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/09/09.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import SwiftMessages

class ReadingItemDialogView: MessageView {
    
    let notificationCenter = NotificationCenter.default
    
    @IBAction func tapToFinishedList() {
        notificationCenter.post(name: .changeItemStateToFinishedReading,
                                object: nil)
    }
    
    @IBAction func tapDelete() {
        notificationCenter.post(name: .deleteFinishedItem,
                                object: nil)
    }
}
