//
//  Loadable.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/09/13.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation
import UIKit

protocol Loadable {
    func showLoadingView()
    func hideLoadingView()
}

extension Loadable where Self: UIViewController {
    
    func showLoadingView() {
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.animate()
        
        loadingView.tag = Constant.ViewTag.indicator
    }
    
    func hideLoadingView() {
        view.subviews.forEach { subview in
            if subview.tag == Constant.ViewTag.indicator {
                subview.removeFromSuperview()
            }
        }
    }
}
