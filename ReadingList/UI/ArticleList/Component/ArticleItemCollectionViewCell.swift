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
    
    // cellのボタンアクションについて（delegate, cloasure）：https://fluffy.es/handling-button-tap-inside-uitableviewcell-without-using-tag/
    var tapAddAction: (() -> Void)?
    
    var article: Article? {
        didSet {
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // cellの再利用について https://stackoverflow.com/questions/45284705/swift-3-tableview-duplicating-loaded-images-from-firebase
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configureCell() {
        guard let item = article else { return }
        
        titleLbl.text = item.title
            self.setImage(imageUrl: item.imageUrl ?? "", url: item.url)        
    }
    
    private func setImage(imageUrl: String, url: String) {
        if imageUrl != "" {
            imageView.setImageByAlamofire(with: URL(string: imageUrl)!)
        } else {
            // OGPから画像取得
            let _ = OGDataProvider.shared.fetchOGData(withURLString: url) { [weak self] ogData, error in
                if let _ = error {
                    return
                }
                
                
                if let imageUrl = ogData.imageUrl as URL? {
                    DispatchQueue.main.async { [weak self] in
                        self?.imageView.setImageByAlamofire(with: imageUrl)
                    }
                }
            }
        }
    }
    
    @IBAction func tapAddButon(_ sender: Any) {
        tapAddAction?()
    }
}
