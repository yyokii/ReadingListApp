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
    
    func configureView(row: Int, item: ReadingItem) {
        baseView.backgroundColor = UIColor.white
        baseView.cornerRadius = 12
        baseView.shadowRadius = 4
        baseView.shadowOpacity = 0.5
        baseView.shadowOffset = CGSize(width: 3, height: 3)
        
        titleLbl.text = item.title
        let formatter = Date.getFormatter()
        
        if let displayDate = item.createdDate {
            dateLbl.text = formatter.string(from: displayDate)
        }
        self.setImage(imageUrl: item.imageUrl, url: item.url)
    }
    
    private func setImage(imageUrl: String, url: String) {
        if imageUrl != "" {
            articleImage.setImageByAlamofire(with: URL(string: imageUrl)!)
        } else {
            // OGPから画像取得
            let _ = OGDataProvider.shared.fetchOGData(withURLString: url) { [weak self] ogData, error in
                if let _ = error {
                    return
                }
                
                if let imageUrl = ogData.imageUrl as URL? {
                    DispatchQueue.main.async { [weak self] in
                        self?.articleImage.setImageByAlamofire(with: imageUrl)
                    }
                }
            }
        }
    }
    
    func redView() {
        dateLbl.textColor = UIColor.darkText
        baseView.backgroundColor = UIColor.init(named: Constant.Color.pinkSherbet)
    }
    
    func yelloeView() {
        dateLbl.textColor = UIColor.darkText
        baseView.backgroundColor = UIColor.init(named: Constant.Color.caramel)
    }
    
    @IBAction func tapOptionButton(_ sender: Any) {
        dateLbl.textColor = UIColor.darkText
        tapOptionBtnAction?()
    }
}
