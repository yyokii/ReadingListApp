//
//  UIViewController+ErrorDialog.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/09/01.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import UIKit

protocol CanDisplayErrorDialog {
    
    func showErrorDialog(message: String, buttonAction: (() -> Void)?)
}

protocol CanDisplayIndicator {
    
    func showIndicator()
    func hideIndicator()
}

extension UIViewController {

    func showErrorDialog(message: String, buttonAction: (() -> Void)?) {

        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        // ボタン作成
        let okAction = UIAlertAction(title: "OK" , style: .default) { (action) -> Void in
            buttonAction?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showIndicator() {
        let indicator = IndicatorView()
        indicator.showIndicator(to: self)
    }
    
    func hideIndicator() {
        IndicatorView.hideIndicator()
    }
}
