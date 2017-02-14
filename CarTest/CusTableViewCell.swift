//
//  CusTableViewCell.swift
//  CarTest
//
//  Created by Rongbin on 16/9/28.
//  Copyright © 2016年 com.xdy. All rights reserved.
// 全部配件Cell

import UIKit

class CusTableViewCell: UITableViewCell {
    let detailView = UIView.init()
    var showMore:Bool = false
    var dic:[String:Any] = Dictionary.init()
    let showMoreButton = UIButton.init(frame: CGRect(x:0,y:0,width:40,height:40))
    var isLoad:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(showMoreButton)
        if showMore {
            showMoreButton.setImage(UIImage.init(named: "cell_down"), for: .normal)
        }else{
        showMoreButton.setImage(UIImage.init(named: "cell_up"), for: .normal)
        }
        showMoreButton.anchorInCorner(Corner.TopRight, xPad: 10, yPad: 0, width: 40, height: 40)
        self.textLabel?.anchorAndFillEdge(Edge.Top, xPad: 10, yPad: 0, otherSize: 40)
        self.textLabel?.backgroundColor = UIColor.clear
        
        let title = dic["part"] as? String ?? "部件名称未录入"
        if title == "部件名称未录入" {
            self.textLabel?.textColor = UIColor.init(red: 221/255.0, green: 86/255.0, blue: 83/255.0, alpha: 1)
        }else{
            self.textLabel?.textColor = UIColor.white
        }
        self.textLabel?.text = title
        detailView.isHidden = !showMore
        detailView.backgroundColor = UIColor.init(white: 0.1, alpha: 0.6)
        self.backgroundColor = UIColor.init(white: 0.3, alpha: 0.2)
        self.addSubview(detailView)
        detailView.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 40, otherSize: 120)
        
        setupDetails()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupDetails(){
        
        if isLoad {
            return
        }else{
            isLoad = true
        }
        
        let titleLength:CGFloat = 60
        //
        let title1 = CULable.init()
        title1.text = "条码"
        detailView.addSubview(title1)
        title1.anchorInCorner(Corner.TopLeft, xPad: 10, yPad: 0, width: titleLength, height: 30)
        
        let conLable1 = UILabel.init()
        conLable1.textColor = UIColor.white
        conLable1.text = dic["partsBarcode"] as? String ?? "未录入"
        detailView.addSubview(conLable1)
        conLable1.alignAndFillWidth(align: .ToTheRightCentered, relativeTo: title1, padding: 0, height: 30)
        if dic["partsBarcode"] == nil || dic["partsBarcode"] as! String == "" {
            conLable1.textColor = UIColor.init(red: 221/255.0, green: 86/255.0, blue: 83/255.0, alpha: 1)
        }
        
        let title2 = CULable.init()
        title2.text = "供应商"
        detailView.addSubview(title2)
        title2.align(.UnderMatchingLeft, relativeTo: title1, padding: 0, width: titleLength, height: 30)
        
        let conLable2 = UILabel.init()
        conLable2.textColor = UIColor.white
        conLable2.text = dic["supplier"] as? String ?? "未录入"
        detailView.addSubview(conLable2)
        conLable2.alignAndFillWidth(align: .ToTheRightCentered, relativeTo: title2, padding: 0, height: 30)
        if dic["supplier"] == nil || dic["supplier"] as! String == "" {
            conLable2.textColor = UIColor.init(red: 221/255.0, green: 86/255.0, blue: 83/255.0, alpha: 1)
        }
        
        let title3 = CULable.init()
        title3.text = "批次"
        detailView.addSubview(title3)
        title3.align(.UnderMatchingLeft, relativeTo: title2, padding: 0, width: titleLength, height: 30)
        
        let conLable3 = UILabel.init()
        conLable3.textColor = UIColor.white
        conLable3.text = dic["batchCode"] as? String ?? "未录入"
        detailView.addSubview(conLable3)
        conLable3.alignAndFillWidth(align: .ToTheRightCentered, relativeTo: title3, padding: 0, height: 30)
        if dic["batchCode"] == nil || dic["batchCode"] as! String == "" {
            conLable3.textColor = UIColor.init(red: 221/255.0, green: 86/255.0, blue: 83/255.0, alpha: 1)
        }
        
        let title4 = CULable.init()
        title4.text = "物料"
        detailView.addSubview(title4)
        title4.align(.UnderMatchingLeft, relativeTo: title3, padding: 0, width: titleLength, height: 30)
        
        let conLable4 = UILabel.init()
        conLable4.textColor = UIColor.white
        conLable4.text = dic["materialCode"] as? String ?? "未录入"
        detailView.addSubview(conLable4)
        conLable4.alignAndFillWidth(align: .ToTheRightCentered, relativeTo: title4, padding: 0, height: 30)
        if dic["materialCode"] == nil || dic["materialCode"] as! String == "" {
            conLable4.textColor = UIColor.init(red: 221/255.0, green: 86/255.0, blue: 83/255.0, alpha: 1)
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("Cell TouchesBegan")
    }

}
