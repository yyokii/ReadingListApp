//
//  IndicatorView.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/07/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit

final class IndicatorView: UIView {
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
    
    private func loadNib() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            configureCircleView()
            self.tag = Constant.ViewTag.indicator
            self.addSubview(view)
        }
    }
    
    func showIndicator(to vc: UIViewController) {
        
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        
        frame = keyWindow.frame
        center = keyWindow.center
        
        if let _ = keyWindow.findSubview(withTag: Constant.ViewTag.indicator) {
            return
        }
        
        keyWindow.animateAddSubView(addTargetView: self, completion: nil)
    }
    
    static func hideIndicator() {
     
        if let indicatorView = UIApplication.shared.keyWindow?.findSubview(withTag: Constant.ViewTag.indicator) as? IndicatorView {
            
            indicatorView.animateRemoveSubView(completion: nil)
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
