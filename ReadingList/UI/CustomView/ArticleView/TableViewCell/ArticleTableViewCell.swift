//
//  ArticleTableViewCell.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/31.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    var articleView: ArticleView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        articleView = ArticleView()
        articleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(articleView)
        articleView.fillSuperview()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(row: Int, item: ReadingItem, type: ListType, tapOptionBtnAction: (() ->  Void)?) {
        articleView.configureView(row: row, item: item, type: type, tapOptionBtnAction: tapOptionBtnAction)
    }
}
