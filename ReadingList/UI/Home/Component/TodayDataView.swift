//
//  TodayDataView.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/11.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit

class TodayDataView: UIView {
    @IBOutlet weak var addDataLbl: UILabel!
    @IBOutlet weak var expire1DayLbl: UILabel!
    @IBOutlet weak var expire2DaysLbl: UILabel!
    
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
    
    func configureView(addDataCount: Int, expire1DayCount: Int, expire2DaysCount: Int) {
        addDataLbl.text = "\(addDataCount)"
        expire1DayLbl.text = "\(expire1DayCount)"
        expire2DaysLbl.text = "\(expire2DaysCount)"
    }
}
