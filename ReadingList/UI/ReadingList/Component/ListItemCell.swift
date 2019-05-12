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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureView(title: String, url: String, date: String) {
        titleLbl.text = title
        dateLbl.text = date
        
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
}
