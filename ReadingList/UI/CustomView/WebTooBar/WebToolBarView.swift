//
//  WebToolBarView.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/10/01.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit

protocol WebToolBarDelegate: class {
    func actionBtnTapped()
    func closeBtnTapped()
    func goBackBtnTapped()
    func goForwardBtnTapped()
}

class WebToolBarView: UIView {
    
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var baseView: UIView!
    
    weak var delegate: WebToolBarDelegate!
    
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
            
            
            //右上と左下を角丸にする設定
            baseView.layer.cornerRadius = 15
            baseView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            self.addSubview(view)
        }
    }
    
    @IBAction func tapItemStateChangeBtn(_ sender: Any) {
        delegate.actionBtnTapped()
    }
    
    @IBAction func tabGoBackBtn(_ sender: Any) {
        delegate.goBackBtnTapped()
    }
    
    @IBAction func tapGoForward(_ sender: Any) {
        delegate.goForwardBtnTapped()
    }
    
    @IBAction func tapCloseBtn(_ sender: Any) {
        delegate.closeBtnTapped()
    }
    
    func configureToReadingListBtn() {
        actionBtn.setTitle("+ 後で読む", for: .normal)
    }
    
    func configureToFinishedListBtn() {
        actionBtn.setTitle("読み終わった！", for: .normal)
    }
}
