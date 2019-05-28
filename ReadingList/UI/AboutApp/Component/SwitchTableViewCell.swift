//
//  SwitchTableViewCell.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/05/29.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import UserNotifications

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var switchView: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// 通知許可状態に基づきスイッチ状態を更新
    func updateSwitchByNotificationSetting() {
        UNUserNotificationCenter.current().getNotificationSettings {[weak self] (settings) in
            if settings.authorizationStatus == .authorized {
                // 通知許可
                self?.switchView.isOn = true
            } else {
                self?.switchView.isOn = false
            }
        }
    }
}
