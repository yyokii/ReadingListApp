//
//  SwitchBtnTableViewCell.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/07/14.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import UserNotifications

class SwitchBtnTableViewCell: UITableViewCell {
    @IBOutlet weak var switchView: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func configureView() {
        switchView.onTintColor = UIColor.init(named: Constant.Color.myrtleGreen)
        updateSwitchByNotificationSetting()
    }
    
    /// 通知許可状態に基づきスイッチ状態を更新
    func updateSwitchByNotificationSetting() {
        UNUserNotificationCenter.current().getNotificationSettings {[weak self] (settings) in
            if settings.authorizationStatus == .authorized {
                // 通知許可されている
                DispatchQueue.main.async {
                    self?.switchView.isOn = true
                }
            } else {
                DispatchQueue.main.async {
                    self?.switchView.isOn = false
                }
            }
        }
    }
    
    @IBAction func tapSwitch(_ sender: Any) {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
