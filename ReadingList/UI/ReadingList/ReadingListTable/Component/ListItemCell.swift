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
    @IBOutlet weak var baseView: DesignableView!
    
    var tapOptionBtnAction: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        articleImage.image = nil
    }
    
    func configureView(row: Int, title: String, url: String, date: Date?) {
        baseView.backgroundColor = UIColor.white
        baseView.cornerRadius = 12
        baseView.shadowRadius = 4
        baseView.shadowOpacity = 0.5
        baseView.shadowOffset = CGSize(width: 3, height: 3)
        
        titleLbl.text = title
        let formatter = Date.getFormatter()
        
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
    
    func redView() {
        dateLbl.textColor = UIColor.darkText
        baseView.backgroundColor = UIColor.init(named: Constant.Color.pinkSherbet)
    }
    
    func yelloeView() {
        baseView.backgroundColor = UIColor.init(named: Constant.Color.caramel)
    }
    
    @IBAction func tapOptionButton(_ sender: Any) {
        dateLbl.textColor = UIColor.darkText
        tapOptionBtnAction?()
    }
}
