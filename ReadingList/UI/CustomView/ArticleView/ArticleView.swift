//
//  ArticleView.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/30.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import SwiftLinkPreview

class ArticleView: UIView {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var dueDateLbl: UILabel!
    @IBOutlet weak var dueDateBaseView: UIView!
    
    private let slp = SwiftLinkPreview(cache: InMemoryCache())
    var tapOptionBtnAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
    
    func fillSuperview() {
        guard let superview = superview else {
            return print("no superview")
        }
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
    }
    
    func configureView(row: Int, item: ReadingListItem, type: ListType, tapOptionBtnAction: (() -> Void)?) {
        
        self.tapOptionBtnAction = tapOptionBtnAction
        
        switch type {
        case .ReadingList:
            // 期限日までの残り日数表示関連view
            dueDateLbl.isHidden = false
            dueDateBaseView.isHidden = false
            
            optionButton.isHidden = false
            
        case .FinishedList:
            
            dueDateLbl.isHidden = true
            dueDateBaseView.isHidden = true
            
            optionButton.isHidden = false
            
        case .DeletedList:
            dueDateLbl.isHidden = true
            dueDateBaseView.isHidden = true
            
            optionButton.isHidden = true
        }
        
        titleLbl.text = item.title
        let formatter = Date.getFormatter()
        dateLbl.text = formatter.string(from: item.createdAt.dateValue())
        
        configureDueDateView(item: item)
        
        // TODO: ここimageurl消してよくね？
        self.setImage(imageUrl: "", url: item.url)
    }
    
    private func configureDueDateView(item: ReadingListItem) {
        
        let now = Date()
        
        // TOOD: fix
        let diff = 0
        
        switch diff {
        case 0, 1:
            dueDateBaseView.backgroundColor = UIColor.init(named: Constant.Color.pinkSherbet)
            dueDateLbl.text = "1"
        case 2:
            dueDateBaseView.backgroundColor = UIColor.init(named: Constant.Color.pinkSherbet)
            dueDateLbl.text = "2"
        case 3:
            dueDateBaseView.backgroundColor = UIColor.init(named: Constant.Color.caramel)
            dueDateLbl.text = "3"
        case 4:
            dueDateBaseView.backgroundColor = UIColor.init(named: Constant.Color.caramel)
            dueDateLbl.text = "4"
        case 5:
            dueDateBaseView.backgroundColor = UIColor.init(named: Constant.Color.cornFlower)
            dueDateLbl.text = "5"
        case 6:
            dueDateBaseView.backgroundColor = UIColor.init(named: Constant.Color.cornFlower)
            dueDateLbl.text = "6"
        case 7:
            dueDateBaseView.backgroundColor = UIColor.init(named: Constant.Color.cornFlower)
            dueDateLbl.text = "7"
        default:
            break
        }
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
    @IBAction func tappedOptionBtn(_ sender: Any) {
        tapOptionBtnAction?()
    }
}
