//
//  DiyButton.swift
//  CarTest
//
//  Created by Rongbin on 16/8/30.
//  Copyright © 2016年 com.xdy. All rights reserved.
//

import UIKit

class DiyButton: UIButton {

    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        self.setTitleColor(UIColor.init(white: 1, alpha: 0.6), for: .highlighted)
    }
}
