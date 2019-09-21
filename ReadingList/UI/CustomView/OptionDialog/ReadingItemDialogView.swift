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
    
    @IBOutlet weak var titleLbl: UILabel!
    
    var title: String = ""
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        configureView(title: title)
    }    
    
    let notificationCenter = NotificationCenter.default
    
    private func configureView(title: String) {
        titleLbl.text = title
    }
    
    @IBAction func tapToFinishedList() {
        notificationCenter.post(name: .changeItemStateToFinishedReading,
                                object: nil)
    }
    
    @IBAction func tapDelete() {
        notificationCenter.post(name: .deleteFinishedItem,
                                object: nil)
    }
}
