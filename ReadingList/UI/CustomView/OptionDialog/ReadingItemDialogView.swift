//
//  ReadingItemDialogView.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/09/09.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import SwiftMessages

protocol ReadingItemDialogViewDelegate: AnyObject {
    func tapToFinishedList()
    func tapDelete()
}

final class ReadingItemDialogView: MessageView {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    weak var delegate: ReadingItemDialogViewDelegate!
    
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
//        notificationCenter.post(name: .changeItemStateToFinishedReading,
//                                object: nil)
        delegate.tapToFinishedList()
        SwiftMessages.hide()
    }
    
    @IBAction func tapDelete() {
//        notificationCenter.post(name: .deleteFinishedItem,
//                                object: nil)
        delegate.tapDelete()
        SwiftMessages.hide()
    }
}
