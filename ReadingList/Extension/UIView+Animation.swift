//
//  UIView+Animation.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/09/04.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import UIKit

extension UIView {
    
    /// viewをアニメーション付きで追加
    func animateAddSubView(addTargetView view: UIView, completion: ((Bool) -> Void)?) {
        
        UIView.transition(with: self, duration: 0.25, options: [.transitionCrossDissolve], animations: { [weak self] in
            
            guard let self = self else { return }
            self.addSubview(view)
            
        }) { isFinished in
            
            completion?(isFinished)
        }
    }
    
    /// viewをアニメーション付きで削除
    func animateRemoveSubView(completion: ((Bool) -> Void)?) {
        
        UIView.transition(with: self, duration: 0.25, options: [.transitionCrossDissolve], animations: { [weak self] in
            
            guard let self = self else { return }
            self.alpha = 0.0
            
        }) { [weak self] isFinished in
            
            guard let self = self else { return }
            self.removeFromSuperview()
            self.alpha = 1.0
        }
    }
}
