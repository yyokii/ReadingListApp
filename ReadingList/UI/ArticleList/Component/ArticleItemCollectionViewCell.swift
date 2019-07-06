//
//  ArticleItemCollectionViewCell.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/05/12.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import SwiftLinkPreview

class ArticleItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    
    private let slp = SwiftLinkPreview(cache: InMemoryCache())
    
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
        
        let plusBtnImage = UIImage(named: "footer_plus")?.withRenderingMode(.alwaysTemplate)
        plusBtn.setImage(plusBtnImage, for: .normal)
        plusBtn.tintColor = UIColor.init(named: Constant.Color.bisque)
        
        titleLbl.text = item.title
        self.setImage(imageUrl: item.imageUrl ?? "", url: item.url)
    }
    
    private func setImage(imageUrl: String, url: String) {
        if imageUrl != "" {
            imageView.setImageByAlamofire(with: URL(string: imageUrl)!)
        } else {
            // OGPから画像取得
            if let url = slp.extractURL(text: url),
                let cached = self.slp.cache.slp_getCachedResponse(url: url.absoluteString),
                let imageUrlString = cached.image,
                let imageUrl = URL(string: imageUrlString) {
                imageView.setImageByAlamofire(with: imageUrl)
                
            } else {
                slp.preview(url,
                            onSuccess: {[weak self] result in
                                if let imageUrlString = result.image, let imageUrl = URL(string: imageUrlString) {
                                    self?.imageView.contentMode = .scaleAspectFill
                                    self?.imageView.setImageByAlamofire(with: imageUrl)
                                } else {
                                    self?.imageView.contentMode = .scaleToFill
                                    self?.imageView.image = UIImage(named: "no_image")
                                }
                    },
                            onError: {[weak self] error in
                                print("\(error)")
                                self?.imageView.contentMode = .scaleToFill
                                self?.imageView.image = UIImage(named: "no_image")
                    }
                )
            }
        }
    }
    
    @IBAction func tapAddButon(_ sender: Any) {
        tapAddAction?()
    }
}
