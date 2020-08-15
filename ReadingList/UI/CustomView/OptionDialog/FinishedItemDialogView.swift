//
//  FinishedItemDialogView.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/09/09.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import SwiftMessages

protocol FinishedItemDialogViewDelegate: AnyObject {
    func tapToReadingList()
    func tapDeleteFinishedItem()
}

final class FinishedItemDialogView: MessageView {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    weak var delegate: FinishedItemDialogViewDelegate!
    
    let notificationCenter = NotificationCenter.default
    
    var title: String = ""

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        configureView(title: title)
    }
    
    private func configureView(title: String) {
        titleLbl.text = title
    }
    
    @IBAction func tapToReadingList() {
        delegate.tapToReadingList()
        SwiftMessages.hide()
    }
    
    @IBAction func tapDelete() {
        delegate.tapDeleteFinishedItem()
        SwiftMessages.hide()
    }
}
