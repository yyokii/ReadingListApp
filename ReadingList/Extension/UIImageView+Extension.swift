//
//  UIImageView+Extension.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/29.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import AlamofireImage

extension UIImageView {
    
    func setImageByAlamofire(with url: URL) {
        af_setImage(withURL: url) { [weak self] response in
            switch response.result {
            case .success(let image):
                
                    self?.image = image
                
            case .failure(let error):
                print(error.localizedDescription)
                self?.image = UIImage(named: "no_image")
                break
            }
        }
    }
}
