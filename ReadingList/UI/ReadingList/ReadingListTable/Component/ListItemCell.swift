//
//  ListItemCell.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/20.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import SwiftLinkPreview

enum ListType {
    case ReadingList
    case FinishedList
    case DeletedList
}

class ListItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var baseView: DesignableView!
    @IBOutlet weak var optionItem: DesignableButton!
    
    private let slp = SwiftLinkPreview(cache: InMemoryCache())
    
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
    
    func configureView(row: Int, item: ReadingItem, type: ListType = .ReadingList) {
        baseView.backgroundColor = UIColor.white
        baseView.cornerRadius = 12
        baseView.shadowRadius = 4
        baseView.shadowOpacity = 0.5
        baseView.shadowOffset = CGSize(width: 3, height: 3)
        
        switch type {
        case .ReadingList, .FinishedList:
            break
        case .DeletedList:
            optionItem.isHidden = true
        }
        
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
            if let url = slp.extractURL(text: url),
                let cached = self.slp.cache.slp_getCachedResponse(url: url.absoluteString),
                let imageUrlString = cached.image,
                let imageUrl = URL(string: imageUrlString) {
                articleImage.setImageByAlamofire(with: imageUrl)
                
            } else {
                slp.preview(url,
                            onSuccess: {[weak self] result in
                                if let imageUrlString = result.image, let imageUrl = URL(string: imageUrlString) {
                                    self?.articleImage.setImageByAlamofire(with: imageUrl)
                                } else {
                                    self?.articleImage.image = UIImage(named: "no_image")
                                }
                    },
                            onError: {[weak self] error in
                                print("\(error)")
                                self?.articleImage.image = UIImage(named: "no_image")
                    }
                )
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
        tapOptionBtnAction?()
    }
}
