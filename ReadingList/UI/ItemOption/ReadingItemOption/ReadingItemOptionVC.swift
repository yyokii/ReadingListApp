//
//  ReadingItemOptionVC.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/06/16.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit

class ReadingItemOptionVC: UIViewController {
    let notificationCenter = NotificationCenter.default

    var tappedItem: ReadingItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenter.addObserver(self, selector: #selector(dismissView), name: .dismissItemOption, object: nil)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapIntoFinished(_ sender: Any) {
        notificationCenter.post(name: .changeItemStateToFinishedReading,
                                object: nil)
    }
    @IBAction func tapDelete(_ sender: Any) {
        notificationCenter.post(name: .deleteReadingItem,
                                object: nil)
    }
}
