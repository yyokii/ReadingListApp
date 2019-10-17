//
//  GraphView.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/29.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import AMPopTip

enum ButtonType: Int {
    case first = 1
    case second = 2
    case third = 3
    case fourth = 4
    case fifth = 5
    case sixth = 6
    case seventh = 7
}

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
    
    var datas: GraphViewModel!

    let popTip = PopTip()
    
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
        self.datas = datas
        
        configurePopTip()
        
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
    
    private func configurePopTip() {
        popTip.font = UIFont(name: "Avenir-Medium", size: 14)!
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        // バブル部分左のマージン
        popTip.edgeMargin = 0
        // 左のオフセット
        popTip.bubbleOffset = 0
        // 対象との距離
        popTip.offset = 2
        // バブル内の上下左右
        popTip.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
        popTip.actionAnimation = .bounce(8)
    }
    
    @IBAction func tapBarAction(sender: UIButton) {
        
        guard let btnType = ButtonType.init(rawValue: sender.tag) else { return }
        
        switch btnType {
        case .first:
            popTip.bubbleColor = UIColor.init(named: Constant.Color.pinkSherbet)!
            popTip.show(text: "\(datas.firstItemsCount)", direction: .up, maxWidth: 100, in: barStackView, from: firstView.frame)
        case .second:
            popTip.bubbleColor = UIColor.init(named: Constant.Color.pinkSherbet)!
            popTip.show(text: "\(datas.secondItemsCount)", direction: .up, maxWidth: 100, in: barStackView, from: secondView.frame)
        case .third:
            
            popTip.bubbleColor = UIColor.init(named: Constant.Color.caramel)!
            popTip.show(text: "\(datas.thirdItemsCount)", direction: .up, maxWidth: 100, in: barStackView, from: thirdView.frame)
        case .fourth:
            popTip.bubbleColor = UIColor.init(named: Constant.Color.caramel)!
            popTip.show(text: "\(datas.fourthItemsCount)", direction: .up, maxWidth: 100, in: barStackView, from: fourthView.frame)
        case .fifth:
            popTip.bubbleColor = UIColor.init(named: Constant.Color.cornFlower)!
            popTip.show(text: "\(datas.fifthItemsCount)", direction: .up, maxWidth: 100, in: barStackView, from: fifthView.frame)
        case .sixth:
            popTip.bubbleColor = UIColor.init(named: Constant.Color.cornFlower)!
            popTip.show(text: "\(datas.sixthItemsCount)", direction: .up, maxWidth: 100, in: barStackView, from: sixthView.frame)
        case .seventh:
            popTip.bubbleColor = UIColor.init(named: Constant.Color.cornFlower)!
            popTip.show(text: "\(datas.seventhItemsCount)", direction: .up, maxWidth: 100, in: barStackView, from: seventhView.frame)
        }
    }
}
