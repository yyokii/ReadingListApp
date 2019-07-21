//
//  Indicator.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/07/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit

class Indicator: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
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
            configureCircleView()
            self.tag = Constant.ViewTag.indicator
            self.addSubview(view)
        }
    }
    
    private func configureCircleView() {
        // CAReplicatorLayerを生成、追加
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = bounds
        layer.addSublayer(replicatorLayer)
        
        // sourceになるSublayerを生成、追加
        let circle = CALayer()
        circle.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        circle.position = center
        circle.position.x -= 40
        circle.backgroundColor = UIColor.init(named: Constant.Color.pinkSherbet)?.cgColor
        circle.cornerRadius = 10
        replicatorLayer.addSublayer(circle)
        
        replicatorLayer.instanceCount = 4
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(30, 0.0, 0.0)
        
        // 上下のアニメーション
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.toValue = center.y + 20
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        circle.add(animation, forKey: "animation")
        
        replicatorLayer.instanceDelay = 0.1
    }
}
