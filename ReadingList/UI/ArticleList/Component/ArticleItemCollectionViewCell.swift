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
//        imageView.contentMode = .scaleToFill
//        imageView.image = nil
    }
    
    func configureCell() {
        guard let item = article else { return }
        
        let plusBtnImage = UIImage(named: "footer_plus")?.withRenderingMode(.alwaysTemplate)
        plusBtn.setImage(plusBtnImage, for: .normal)
        plusBtn.tintColor = UIColor.init(named: Constant.Color.pinkSherbet)
        
        titleLbl.text = item.title
        
        // 非同期コンテンツが読み込まれるまで他の画像が表示されないようにする https://ja.stackoverflow.com/questions/27845/uitableview%E3%81%AE%E3%82%BB%E3%83%AB%E3%81%8C%E5%86%8D%E5%88%A9%E7%94%A8%E3%81%95%E3%82%8C%E3%82%8B%E9%9A%9B%E3%81%AB%E5%89%8D%E3%81%AE%E7%94%BB%E5%83%8F%E3%81%AA%E3%81%A9%E3%81%8C%E6%AE%8B%E3%81%A3%E3%81%A6%E3%81%97%E3%81%BE%E3%81%86%E5%A0%B4%E5%90%88%E3%81%AE%E5%AF%BE%E5%87%A6
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
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
                                    self?.imageView.setImageByAlamofire(with: imageUrl)
                                } else {
                                    self?.imageView.image = UIImage(named: "no_image")
                                }
                    },
                            onError: {[weak self] error in
                                print("\(error)")
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
