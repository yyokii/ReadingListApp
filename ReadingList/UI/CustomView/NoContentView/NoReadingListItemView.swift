//
//  NoReadingListItemView.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/07/21.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit

class NoReadingListItemView: UIView {
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
}
