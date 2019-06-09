//
//  ListItemCell.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/20.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import URLEmbeddedView

class ListItemCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    
    var row: Int?
    
    let notificationCenter = NotificationCenter.default
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureView(row: Int, title: String, url: String, date: Date?) {
        self.row = row
        titleLbl.text = title
        let formatter = Date().getFormatter()
        
        if let displayDate = date {
            dateLbl.text = formatter.string(from: displayDate)
        }
        
        let _ = OGDataProvider.shared.fetchOGData(withURLString: url) { [weak self] ogData, error in
            if let _ = error {
                return
            }
            
            if let imageUrl = ogData.imageUrl as URL? {
                DispatchQueue.main.async{
                    self?.articleImage.setImageByAlamofire(with: imageUrl)
                }
            }
        }
    }
    @IBAction func tapOptionButton(_ sender: Any) {
        let info = ["row": row!]
        notificationCenter.post(name: .showItemOption, object: nil, userInfo: info)
    }
}
