//
//  CULable.swift
//  CarTest
//
//  Created by Rongbin on 16/9/23.
//  Copyright © 2016年 com.xdy. All rights reserved.
//

import UIKit

class CULable: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
 
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
 */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: 14)
    }

}
