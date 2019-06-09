//
//  ArticleItemCollectionViewCell.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/05/12.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import URLEmbeddedView

class ArticleItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var article: Article? {
        didSet {
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell() {
        guard let item = article else { return }
        
        titleLbl.text = article?.title
        let _ = OGDataProvider.shared.fetchOGData(withURLString: item.url) { [weak self] ogData, error in
            if let _ = error {
                return
            }
            
            if let imageUrl = ogData.imageUrl as URL? {
                DispatchQueue.main.async{
                    self?.imageView.setImageByAlamofire(with: imageUrl)
                }
            }
        }
    }
}
