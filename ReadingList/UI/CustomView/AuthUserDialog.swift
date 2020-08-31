//
//  AuthUserDialog.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/23.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation
import UIKit

struct AuthUserDialog {
    
    static func createRegisterDialog(registerAction: @escaping (_ mail: String, _ pass: String) -> Void, loginAction: @escaping (_ mail: String, _ pass: String) -> Void) -> UIAlertController {
        
        let alert = UIAlertController(title: "新規登録 or ログイン", message: "\n新規登録すると他の端末にデータを引き継ぐことができるようになります。\n\n ※ 新規登録しない場合、アプリを消した場合にデータが失われてしまいます😢", preferredStyle: .alert)
        
        
        var mailTextField: UITextField!
        var passTextField: UITextField!
        
        // メールアドレス入力用テキストフィールド
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "メールアドレス"
            textField.keyboardType = .emailAddress
            textField.tag = 0
            mailTextField = textField
        })
        
        // パスワード入力用テキストフィールド
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "英数字8文字以上のパスワード"
            textField.keyboardType = .alphabet
            textField.tag = 1
            passTextField = textField
        })
        
        // ボタン作成
        let cancelAction = UIAlertAction(title: "キャンセル" , style: .cancel)
        let loginAction = UIAlertAction(title: "ログイン" , style: .default) { (action) -> Void in
            
            let mail = mailTextField.text ?? ""
            let pass = passTextField.text ?? ""
            
            loginAction(mail, pass)
        }
        let saveAction = UIAlertAction(title: "新規登録", style: .default) { (action) -> Void in
            
            let mail = mailTextField.text ?? ""
            let pass = passTextField.text ?? ""
            
            registerAction(mail, pass)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        alert.addAction(loginAction)
        
        return alert
    }
    
    /// ログアウトダイアログ
    static func createLogoutDialog(logoutAction: @escaping () -> Void) -> UIAlertController {
        
        let alert = UIAlertController(title: "ログアウト", message: "\n現在ログインしています。\n\nログアウトしますか？", preferredStyle: .alert)
        
        // ボタン作成
        let cancelAction = UIAlertAction(title: "キャンセル" , style: .cancel)
        let logoutAction = UIAlertAction(title: "ログアウト" , style: .default) { (action) -> Void in
            
            logoutAction()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        
        return alert
    }
}
