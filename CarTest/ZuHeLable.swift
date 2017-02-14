//
//  ZuHeLable.swift
//  CarTest
//
//  Created by Rongbin on 16/9/27.
//  Copyright © 2016年 com.xdy. All rights reserved.
//  组合Lable 由标题和内容组成

import UIKit

class ZuHeLable: UIView {

    let titleLable = CULable.init()
    let contentLable = CULable.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        self.addSubview(titleLable)
        
        self.addSubview(contentLable)
        
        self.groupInCenter(group: Group.Horizontal, views: [titleLable,contentLable], padding: 0, width: self.bounds.width/2, height: 40)
    }
}
