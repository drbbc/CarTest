//
//  CarInfoViewController.swift
//  CarTest
//
//  Created by Rongbin on 16/9/14.
//  Copyright © 2016年 com.xdy. All rights reserved.
//  车辆状态

import UIKit

class CarInfoViewController: BaseViewController {

    let cf = Config.share
    var carInfo:[String:Any] = Dictionary.init()
    var errMsg:[String:Any] = Dictionary.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "车辆状态"
        loadCarInfo()
    }
    
    func setupMainUI() {
        let titleLable = CLable.init()
        //title.textColor = UIColor.white
        titleLable.isWhiteBg = true
        //title.backgroundColor = UIColor.init(white: 0.2, alpha: 0.5)
        titleLable.text = "   最后上报时间"
        self.view.addSubview(titleLable)
        titleLable.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 40)
        
        //line2
        let titleLable2 = CLable.init()
        titleLable2.text = "   采集："
        self.view.addSubview(titleLable2)
        titleLable2.align(.UnderMatchingLeft, relativeTo: titleLable, padding: 0, width: 60, height: 40)
        let caijiTime = CLable.init()
        caijiTime.text = cf.getDateStr(carInfo["collect_time"])
        self.view.addSubview(caijiTime)
        caijiTime.align(.ToTheRightCentered, relativeTo: titleLable2, padding: 0, width: self.view.bounds.width/2-60, height: 40)
        
        let titleLable3 = CLable.init()
        titleLable3.text = "接收："
        self.view.addSubview(titleLable3)
        titleLable3.align(.ToTheRightCentered, relativeTo: caijiTime, padding: 0, width: 60, height: 40)
        let jieshouTime = CLable.init()
        jieshouTime.text = cf.getDateStr(carInfo["receive_time"])
        self.view.addSubview(jieshouTime)
        jieshouTime.alignAndFillWidth(align: .ToTheRightCentered, relativeTo: titleLable3, padding: 0, height: 40)
        //电量
        let titleLable4 = CLable.init()
        titleLable4.isWhiteBg = true
        titleLable4.text = "   剩余电量："
        self.view.addSubview(titleLable4)
        titleLable4.align(.UnderMatchingLeft, relativeTo: titleLable2, padding: 0, width: 100, height: 40)
        
        let batteryLable = CLable.init()
        batteryLable.isWhiteBg = true
        self.view.addSubview(batteryLable)
        batteryLable.text = "\(carInfo["leave_battery"] as? String ?? "0")%"
        batteryLable.alignAndFillWidth(align: .ToTheRightCentered, relativeTo: titleLable4, padding: 0, height: 40)
        
        //
        //line4
        let titleLable5 = CLable.init()
        titleLable5.text = "   总里程："
        self.view.addSubview(titleLable5)
        titleLable5.align(.UnderMatchingLeft, relativeTo: titleLable4, padding: 0, width: 70, height: 40)
        let conLable = CLable.init()
        let mile:Float = Float(carInfo["mile_age"] as? String ?? "0")!
        conLable.text = String(mile/10.0)+" KM"
        self.view.addSubview(conLable)
        conLable.align(.ToTheRightCentered, relativeTo: titleLable5, padding: 0, width: self.view.bounds.width/2-70, height: 40)
        
        let titleLable6 = CLable.init()
        titleLable6.text = "总电压："
        self.view.addSubview(titleLable6)
        titleLable6.align(.ToTheRightCentered, relativeTo: conLable, padding: 0, width: 60, height: 40)
        let conLable1 = CLable.init()
        
        conLable1.text = carInfo["total_voltage"] as? String ?? ""
        self.view.addSubview(conLable1)
        conLable1.alignAndFillWidth(align: .ToTheRightCentered, relativeTo: titleLable6, padding: 0, height: 40)
        
        //单体电压
        let titleLable7 = CLable.init()
        titleLable7.isWhiteBg = true
        self.view.addSubview(titleLable7)
        titleLable7.align(.UnderMatchingLeft, relativeTo: titleLable5, padding: 0, width: self.view.bounds.width/3, height: 40)
        let titleLable8 = CLable.init()
        titleLable8.isWhiteBg = true
        titleLable8.text = "单体电压"
        titleLable8.textAlignment = .center
        self.view.addSubview(titleLable8)
        titleLable8.align(.ToTheRightCentered, relativeTo: titleLable7, padding: 0, width: self.view.bounds.width/3, height: 40)
        let titleLable9 = CLable.init()
        titleLable9.isWhiteBg = true
        titleLable9.text = "温度"
        titleLable9.textAlignment = .center
        self.view.addSubview(titleLable9)
        titleLable9.align(.ToTheRightCentered, relativeTo: titleLable8, padding: 0, width: self.view.bounds.width/3, height: 40)
        
        //Max
        let titleLable10 = CLable.init()
        titleLable10.text = "MAX"
        titleLable10.textAlignment = .center
        self.view.addSubview(titleLable10)
        titleLable10.align(.UnderMatchingLeft, relativeTo: titleLable7, padding: 0, width: self.view.bounds.width/3, height: 40)
        
        let maxHight = CLable.init()
        maxHight.textAlignment = .center
        maxHight.text = carInfo["voltage_highest"] as? String ?? ""
        self.view.addSubview(maxHight)
        maxHight.align(.ToTheRightCentered, relativeTo: titleLable10, padding: 0, width: self.view.bounds.width/3, height: 40)
        
        let maxHight1 = CLable.init()
        maxHight1.textAlignment = .center
        maxHight1.text = carInfo["temp_highest"] as? String ?? ""
        self.view.addSubview(maxHight1)
        maxHight1.align(.ToTheRightCentered, relativeTo: maxHight, padding: 0, width: self.view.bounds.width/3, height: 40)
        
        let line = UIView.init()
        line.backgroundColor = UIColor.init(white: 0.7, alpha: 0.8)
        self.view.addSubview(line)
        line.align(.UnderMatchingLeft, relativeTo: titleLable10, padding: 0, width: self.view.bounds.width, height: 1)
        
        //Min
        let titleLable11 = CLable.init()
        titleLable11.text = "MIN"
        titleLable11.textAlignment = .center
        self.view.addSubview(titleLable11)
        titleLable11.align(.UnderMatchingLeft, relativeTo: line, padding: 0, width: self.view.bounds.width/3, height: 40)
        
        let minHight = CLable.init()
        minHight.textAlignment = .center
        minHight.text = carInfo["voltage_lowest"] as? String ?? ""
        self.view.addSubview(minHight)
        minHight.align(.ToTheRightCentered, relativeTo: titleLable11, padding: 0, width: self.view.bounds.width/3, height: 40)
        
        let minHight1 = CLable.init()
        minHight1.textAlignment = .center
        minHight1.text = carInfo["temp_lowest"] as? String ?? ""
        self.view.addSubview(minHight1)
        minHight1.align(.ToTheRightCentered, relativeTo: minHight, padding: 0, width: self.view.bounds.width/3, height: 40)
        
        let line1 = UIView.init()
        //line1.backgroundColor = UIColor.init(white: 0.7, alpha: 0.8)
        self.view.addSubview(line1)
        line1.align(.UnderMatchingLeft, relativeTo: titleLable11, padding: 0, width: self.view.bounds.width, height: 10)
        
        let titleLable12 = CLable.init()
        titleLable12.isWhiteBg = true
        titleLable12.text = "   报警信息"
        self.view.addSubview(titleLable12)
        titleLable12.align(.UnderMatchingLeft, relativeTo: line1, padding: 0, width: self.view.bounds.width, height: 40)
        
        let line2 = UIView.init()
        //line1.backgroundColor = UIColor.init(white: 0.7, alpha: 0.8)
        self.view.addSubview(line2)
        line2.align(.UnderMatchingLeft, relativeTo: titleLable12, padding: 0, width: self.view.bounds.width, height: 5)
        
        
        
    }
    
    func setupMsgUI(_ view:UIView){
        
    }
    
    func setupNODataUI(){
        
    }
    
    func loadCarInfo(){
        let parms = ["vinCode":cf.vinCode as AnyObject,"token":cf.token as AnyObject]
        let http = HttpRequest.sharedInstance
        
        let spinner = SwiftSpinner.show("加载中")
        http.request(http.uri+"carInfo", parm: parms) { (isSuccess, result) in
            if isSuccess {
                spinner.title = "成功"
                self.carInfo = result as? [String:Any] ?? Dictionary.init()
                self.setupMainUI()
            }else{
                self.setupNODataUI()
            }
            
            spinner.delay(0.5, completion: { 
                SwiftSpinner.hide()
            })
        }
    }
    
    func loadErrMsg(){
        let parms = ["vinCode":cf.vinCode as AnyObject,"token":cf.token as AnyObject]
        let http = HttpRequest.sharedInstance
        
//        let spinner = SwiftSpinner.show("加载中")
        http.request(http.uri+"carAlarm", parm: parms) { (isSuccess, result) in
            if isSuccess {
//                spinner.title = "成功"
                self.errMsg = result as? [String:Any] ?? Dictionary.init()
                self.setupMainUI()
            }
//            
//            spinner.delay(0.5, completion: {
//                SwiftSpinner.hide()
//            })
        }

    }

    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
    }

}

class CLable: UILabel {
    var isWhiteBg:Bool = false
    override func layoutSubviews() {
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: 14)
        if isWhiteBg {
            self.backgroundColor = UIColor.init(white: 0.4, alpha: 0.3)
        }else{
            self.backgroundColor = UIColor.init(white: 0.2, alpha: 0.3)
        }
    }
}
