//
//  GraphView.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/29.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    @IBOutlet weak var totalCountLabel: UILabel!
    
    @IBOutlet weak var barStackView: UIStackView!
    @IBOutlet weak var seventhView: DesignableView!
    @IBOutlet weak var sixthView: DesignableView!
    @IBOutlet weak var fifthView: DesignableView!
    @IBOutlet weak var fourthView: DesignableView!
    @IBOutlet weak var thirdView: DesignableView!
    @IBOutlet weak var secondView: DesignableView!
    @IBOutlet weak var firstView: DesignableView!
    
    var seventhViewConstraint: NSLayoutConstraint!
    var sixthViewConstraint: NSLayoutConstraint!
    var fifthViewConstraint: NSLayoutConstraint!
    var fourthViewConstraint: NSLayoutConstraint!
    var thirdViewConstraint: NSLayoutConstraint!
    var secondViewConstraint: NSLayoutConstraint!
    var firstViewConstraint: NSLayoutConstraint!

    
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
    
    func configureView(datas: GraphViewModel) {
        totalCountLabel.text = "\(datas.totalCount)"
        
        if let seventhConstraint = self.seventhViewConstraint {
            seventhConstraint.isActive = false
        }
        if let sixthViewConstraint = self.sixthViewConstraint {
            sixthViewConstraint.isActive = false
        }
        if let fifthViewConstraint = self.fifthViewConstraint {
            fifthViewConstraint.isActive = false
        }
        if let fourthViewConstraint = self.fourthViewConstraint {
            fourthViewConstraint.isActive = false
        }
        if let thirdViewConstraint = self.thirdViewConstraint {
            thirdViewConstraint.isActive = false
        }
        if let secondViewConstraint = self.secondViewConstraint {
            secondViewConstraint.isActive = false
        }
        if let firstViewConstraint = self.firstViewConstraint {
            firstViewConstraint.isActive = false
        }
        
        seventhViewConstraint = seventhView.heightAnchor.constraint(equalToConstant: datas.seventhBarHeight)
        seventhViewConstraint.isActive = true
        
        sixthViewConstraint = sixthView.heightAnchor.constraint(equalToConstant: datas.sixthBarHeight)
        sixthViewConstraint.isActive = true
        
        fifthViewConstraint = fifthView.heightAnchor.constraint(equalToConstant: datas.fifthBarHeight)
        fifthViewConstraint.isActive = true
        
        fourthViewConstraint = fourthView.heightAnchor.constraint(equalToConstant: datas.fourthBarHeight)
        fourthViewConstraint.isActive = true
        
        thirdViewConstraint = thirdView.heightAnchor.constraint(equalToConstant: datas.thirdBarHeight)
        thirdViewConstraint.isActive = true
        
        secondViewConstraint = secondView.heightAnchor.constraint(equalToConstant: datas.secondBarHeight)
        secondViewConstraint.isActive = true
        
        firstViewConstraint = firstView.heightAnchor.constraint(equalToConstant: datas.firstBarHeight)
        firstViewConstraint.isActive = true
    }
}
