//
//  PlugnInfoViewController.swift
//  CarTest
//
//  Created by Rongbin on 16/9/14.
//  Copyright © 2016年 com.xdy. All rights reserved.
//  零部件信息

import UIKit

class PlugnInfoViewController: BaseViewController {

    var pluginInfo:Dictionary<String,Any> = Dictionary.init()
    let cf = Config.share
    let http = HttpRequest.sharedInstance
    var errPlugins:Array<[String:Any]> = Array.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "零部件信息"
        loadPluginInfo()
    }
    
    func setupMainUI() {
        let car = pluginInfo["car"] as! [String:Any]
        let list:Array<[String:Any]> = pluginInfo["cardList"] as? Array ?? []
        let scrool = UIScrollView.init(frame:self.view.bounds)
        self.view.addSubview(scrool)
//        scrool.fillSuperview(left: 0, right: 0, top: 0, bottom: 0)
        //        print(list)
        let titleLength:CGFloat = 90
        //let bgColor1 = UIColor.init(white: 0.5, alpha: 0.3)
        let bgColor2 = UIColor.init(white: 0.5, alpha: 0.2)
        //1行
        let title1 = CULable.init()
        scrool.addSubview(title1)
        title1.text = "   VIN号"
        title1.backgroundColor = bgColor2
        title1.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 5, width: titleLength, height: 40)
        
        let vinLable = CULable.init()
        scrool.addSubview(vinLable)
        vinLable.text = cf.vinCode
        vinLable.backgroundColor = bgColor2
        vinLable.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title1, padding: 0, height: 40)
        
        //2行
        let title2 = CULable.init()
        scrool.addSubview(title2)
        title2.text = "   审核状态"
        //title2.backgroundColor = bgColor1
        title2.align(Align.UnderMatchingLeft, relativeTo: title1, padding: 0, width: titleLength, height: 40)
        let flagLable = CULable.init()
        //flagLable.backgroundColor = bgColor1
        scrool.addSubview(flagLable)
        flagLable.text = car["flagDesc"] as? String
        flagLable.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title2, padding: 0, height: 40)
        
        let flag =  car["flag"] as? Int ?? 0
        
        if flag == 4 || flag == 1 {
            if cf.isAdmin {
                let checkButton  = UIButton.init()
                checkButton.setTitle("审核", for: .normal)
                checkButton.backgroundColor = UIColor.init(red: 28/255.0, green: 154/255.0, blue: 212/255.0, alpha: 1)
                checkButton.layer.cornerRadius = 5
                flagLable.addSubview(checkButton)
                checkButton.anchorToEdge(Edge.Right, padding: 10, width: 60, height: 30)
            }
        }
        
        switch flag {
        case 0,4,8:
            flagLable.textColor = UIColor.init(red: 219/255.0, green: 83/255.0, blue: 81/255.0, alpha:1 )
            break;
        case 1:
            flagLable.textColor = UIColor.yellow
            break;
        default:
            flagLable.textColor = UIColor.green
            break;
        }
        //两例显示时
        
        let title3 = CULable.init()
        title3.backgroundColor = bgColor2
        title3.text = "   颜色"
        scrool.addSubview(title3)
        title3.align(Align.UnderMatchingLeft, relativeTo: title2, padding: 0, width: titleLength-40, height: 40)
        
        let colorLable = CULable.init()
        colorLable.backgroundColor = bgColor2
        colorLable.text = car["colorDesc"] as? String
        scrool.addSubview(colorLable)
        colorLable.align(Align.ToTheRightCentered, relativeTo: title3, padding: 0, width: self.view.bounds.width/2-title3.bounds.width, height: 40)
        
        
        //
        let title4 = CULable.init()
        title4.backgroundColor = bgColor2
        title4.text = " 配置"
        scrool.addSubview(title4)
        title4.align(Align.ToTheRightCentered, relativeTo: colorLable, padding: 0, width: titleLength-40, height: 40)
        
        let cfgLable = CULable.init()
        cfgLable.backgroundColor = bgColor2
        cfgLable.text = car["confDesc"] as? String
        scrool.addSubview(cfgLable)
        cfgLable.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title4, padding: 0, height: 40)
        
        //产地
        let title5 = CULable.init()
        title5.text = "   产地"
        scrool.addSubview(title5)
        title5.align(Align.UnderMatchingLeft, relativeTo: title3, padding: 0, width: titleLength-40, height: 40)
        
        let madeAreaLable = CULable.init()
        madeAreaLable.text = car["madeInDesc"] as? String
        scrool.addSubview(madeAreaLable)
        madeAreaLable.align(Align.ToTheRightCentered, relativeTo: title5, padding: 0, width: self.view.bounds.width/2-title5.bounds.width, height: 40)
        
        
        //
        let title6 = CULable.init()
        title6.text = " 销往"
        scrool.addSubview(title6)
        title6.align(Align.ToTheRightCentered, relativeTo: madeAreaLable, padding: 0, width: titleLength-40, height: 40)
        
        let soldToLable = CULable.init()
        soldToLable.text = car["soldToDesc"] as? String
        scrool.addSubview(soldToLable)
        soldToLable.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title6, padding: 0, height: 40)
        
        //电池类型
        let title7 = CULable.init()
        title7.backgroundColor = bgColor2
        title7.text = "   电池类型"
        scrool.addSubview(title7)
        title7.align(Align.UnderMatchingLeft, relativeTo: title5, padding: 0, width: titleLength, height: 40)
        
        let batteryTypeLable = CULable.init()
        batteryTypeLable.backgroundColor = bgColor2
        batteryTypeLable.text = car["batteryTypeDesc"] as? String
        scrool.addSubview(batteryTypeLable)
        batteryTypeLable.align(Align.ToTheRightCentered, relativeTo: title7, padding: 0, width: self.view.bounds.width/2-title7.bounds.width, height: 40)
        
        //
        let title8 = CULable.init()
        title8.backgroundColor = bgColor2
        title8.text = "是否租赁"
        scrool.addSubview(title8)
        title8.align(Align.ToTheRightCentered, relativeTo: batteryTypeLable, padding: 0, width: titleLength, height: 40)
        
        let isLeaseLable = CULable.init()
        isLeaseLable.backgroundColor = bgColor2
        let isLease = car["isLease"] as? Int ?? 0
        isLeaseLable.text = isLease == 0 ? "否" : "是"
        scrool.addSubview(isLeaseLable)
        isLeaseLable.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title8, padding: 0, height: 40)
        
        //上线日期
        let title9 = CULable.init()
        //title9.backgroundColor = bgColor1
        title9.text = "   上线日期"
        scrool.addSubview(title9)
        title9.align(Align.UnderMatchingLeft, relativeTo: title7, padding: 0, width: titleLength, height: 40)
        
        let inTimeLable = CULable.init()
        //inTimeLable.backgroundColor = bgColor1
        let inTimeStr = car["inTime"] as? String
        let instrArr = inTimeStr?.components(separatedBy: " ")
        inTimeLable.text = instrArr?[0]
        
        scrool.addSubview(inTimeLable)
        inTimeLable.align(Align.ToTheRightCentered, relativeTo: title9, padding: 0, width: self.view.bounds.width/2-title9.bounds.width, height: 40)
        
        //
        let title10 = CULable.init()
        //title10.backgroundColor = bgColor1
        title10.text = "下线日期"
        scrool.addSubview(title10)
        title10.align(Align.ToTheRightCentered, relativeTo: inTimeLable, padding: 0, width: titleLength-20, height: 40)
        
        let outTimeLable = CULable.init()
        //outTimeLable.backgroundColor = bgColor1
        let outTimeStr = car["outTime"] as? String
        let strArr = outTimeStr?.components(separatedBy: " ")
        outTimeLable.text = strArr?[0]
        scrool.addSubview(outTimeLable)
        outTimeLable.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title10, padding: 0, height: 40)
        
        //车型
        let title21 = CULable.init()
        title21.backgroundColor = bgColor2
        scrool.addSubview(title21)
        title21.text = "   车型"
        title21.align(Align.UnderMatchingLeft, relativeTo: title9, padding: 0, width: titleLength, height: 40)
        let modelIdLable = CULable.init()
        modelIdLable.backgroundColor = bgColor2
        scrool.addSubview(modelIdLable)
        modelIdLable.text = car["modelId"] as? String
        modelIdLable.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title21, padding: 0, height: 40)
        
        //电机号
        let title22 = CULable.init()
        scrool.addSubview(title22)
        title22.text = "   电机号"
        title22.align(Align.UnderMatchingLeft, relativeTo: title21, padding: 0, width: titleLength, height: 40)
        let electricMotorCode = CULable.init()
        scrool.addSubview(electricMotorCode)
        electricMotorCode.text = car["electricMotorCode"] as? String
        electricMotorCode.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title22, padding: 0, height: 40)
        
        //电池包
        let title23 = CULable.init()
        title23.backgroundColor = bgColor2
        scrool.addSubview(title23)
        title23.text = "   电池包"
        title23.align(Align.UnderMatchingLeft, relativeTo: title22, padding: 0, width: titleLength, height: 40)
        let batteryPackNo = CULable.init()
        batteryPackNo.backgroundColor = bgColor2
        scrool.addSubview(batteryPackNo)
        batteryPackNo.text = car["batteryPackNo"] as? String
        batteryPackNo.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title23, padding: 0, height: 40)
        
        //GPS
        let title24 = CULable.init()
        scrool.addSubview(title24)
        title24.text = "   GPS"
        title24.align(Align.UnderMatchingLeft, relativeTo: title23, padding: 0, width: titleLength, height: 40)
        let gpsCodeLable = CULable.init()
        scrool.addSubview(gpsCodeLable)
        gpsCodeLable.text = car["gpsCode"] as? String
        gpsCodeLable.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title24, padding: 0, height: 40)
        
        //3G卡
        let title25 = CULable.init()
        title25.backgroundColor = bgColor2
        scrool.addSubview(title25)
        title25.text = "   3G卡"
        title25.align(Align.UnderMatchingLeft, relativeTo: title24, padding: 0, width: titleLength, height: 40)
        let gLable = CULable.init()
        gLable.backgroundColor = bgColor2
        scrool.addSubview(gLable)
        gLable.text = car["cardNo3G"] as? String
        gLable.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title25, padding: 0, height: 40)
        
        //电控号
        let title26 = CULable.init()
        scrool.addSubview(title26)
        title26.text = "   电控号"
        title26.align(Align.UnderMatchingLeft, relativeTo: title25, padding: 0, width: titleLength, height: 40)
        let controllerCode = CULable.init()
        scrool.addSubview(controllerCode)
        controllerCode.text = car["controllerCode"] as? String
        controllerCode.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title26, padding: 0, height: 40)
        //录入总数
        let title27 = CULable.init()
        title27.backgroundColor = bgColor2
        scrool.addSubview(title27)
        title27.text = "   录入总数"
        title27.align(Align.UnderMatchingLeft, relativeTo: title26, padding: 0, width: titleLength, height: 40)
        let allCountLable = CULable.init()
        allCountLable.backgroundColor = bgColor2
        scrool.addSubview(allCountLable)
        allCountLable.text = "\(list.count)条"
        allCountLable.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title27, padding: 0, height: 40)
        
        let showAllButton = UIButton.init()
        showAllButton.setTitle("全部", for: .normal)
        showAllButton.layer.cornerRadius = 5
        showAllButton.addTarget(self, action: #selector(pluginListAction), for: .touchUpInside)
        showAllButton.backgroundColor = UIColor.init(red: 28/255.0, green: 154/255.0, blue: 212/255.0, alpha: 1)
        
        allCountLable.addSubview(showAllButton)
        allCountLable.isUserInteractionEnabled = true
        showAllButton.bringSubview(toFront: allCountLable)
        showAllButton.anchorToEdge(Edge.Right, padding: 5, width: 100, height: 30)
        
        let line = UIView.init()
        scrool.addSubview(line)
        line.align(Align.UnderMatchingLeft, relativeTo: title27, padding: 0, width: self.view.bounds.width, height: 10)
        
        var codeErr = 0 //条码错误
        var objectErr = 0 //物料不能解析
        var declearErr = 0 //供应商不能解析
        var madeCodeErr = 0 //生产批次有误
        //计算错误条数
        for i in 0...list.count-1 {
            let dic = list[i]
            if dic["batchCode"] == nil {
                madeCodeErr+=1
                errPlugins.insert(dic,at:i)
            }
            
            if dic["materialCode"] == nil {
                objectErr+=1
                errPlugins.insert(dic,at:i)
            }
            
            if dic["partsBarcode"] == nil {
                codeErr+=1
                errPlugins.insert(dic,at:i)
            }
            
            if dic["supplier"] == nil {
                declearErr+=1
                errPlugins.insert(dic,at:i)
            }
        }
        
        //
        let title30 = CULable.init()
        title30.backgroundColor = bgColor2
        scrool.addSubview(title30)
        title30.text = "   条码有误"
        title30.align(Align.UnderMatchingLeft, relativeTo: line, padding: 0, width: titleLength+50, height: 40)
        let allCountLable1 = CULable.init()
        allCountLable1.backgroundColor = bgColor2
        scrool.addSubview(allCountLable1)
        allCountLable1.text = "\(codeErr)条"
        allCountLable1.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title30, padding: 0, height: 40)
        
        let title31 = CULable.init()
        title31.backgroundColor = bgColor2
        scrool.addSubview(title31)
        title31.text = "   物料不能解析"
        title31.align(Align.UnderMatchingLeft, relativeTo: title30, padding: 0, width: titleLength+50, height: 40)
        let allCountLable2 = CULable.init()
        allCountLable2.backgroundColor = bgColor2
        scrool.addSubview(allCountLable2)
        allCountLable2.text = "\(objectErr)条"
        allCountLable2.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title31, padding: 0, height: 40)
        
        let title32 = CULable.init()
        title32.backgroundColor = bgColor2
        scrool.addSubview(title32)
        title32.text = "   供应商不能解析"
        title32.align(Align.UnderMatchingLeft, relativeTo: title31, padding: 0, width: titleLength+50, height: 40)
        let allCountLable3 = CULable.init()
        allCountLable3.backgroundColor = bgColor2
        scrool.addSubview(allCountLable3)
        allCountLable3.text = "\(declearErr)条"
        allCountLable3.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title32, padding: 0, height: 40)
        
        let title33 = CULable.init()
        title33.backgroundColor = bgColor2
        scrool.addSubview(title33)
        title33.text = "   生产批次有误"
        title33.align(Align.UnderMatchingLeft, relativeTo: title32, padding: 0, width: titleLength+50, height: 40)
        let allCountLable4 = CULable.init()
        allCountLable4.backgroundColor = bgColor2
        scrool.addSubview(allCountLable4)
        allCountLable4.text = "\(madeCodeErr)条"
        allCountLable4.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: title33, padding: 0, height: 40)
        
        //查看详情
        let showMoreButton = UIButton.init()
        scrool.addSubview(showMoreButton)
        showMoreButton.setTitle("查看详情", for: .normal)
        showMoreButton.layer.cornerRadius = 5
        showMoreButton.addTarget(self, action: #selector(showDetailsAction), for: .touchUpInside)
        showMoreButton.backgroundColor = UIColor.init(red: 28/255.0, green: 154/255.0, blue: 212/255.0, alpha: 1)
        showMoreButton.align(Align.UnderMatchingRight, relativeTo: line, padding: 0, width: 100, height: 160,offset:-5)
        
        scrool.contentSize = CGSize(width: self.view.bounds.width, height: 655+40)
    }
    
    func setupNoDataUI(){
        //数据加载失败显示界面 提示：数据为空！请检查VIN或一车一档信息.
    }
    //条码有误
//    func codeErrCount(list:Array<Any>) -> Int{
//        return list.count
//    }
//    
//    func objectErrCount(list:Array<Any>) -> Int{
//        return list.count
//    }
    
    func loadPluginInfo(){
        let parms = ["vinCode":cf.vinCode as AnyObject,"token":cf.token as AnyObject]
        let spinner = SwiftSpinner.show("加载中")
        http.request(http.uri+"carPartsInfo", parm: parms) { (isSuccess, result) in
            if isSuccess {
                spinner.title = "成功"
                self.pluginInfo = result as! [String:Any]
                self.setupMainUI()
            }else{
                spinner.title = "失败"
                self.setupNoDataUI()
            }
            
            spinner.delay(0.5, completion: { 
                let _ = SwiftSpinner.hide()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - 所有配件页
    func pluginListAction()
    {
        let list:Array<[String:Any]> = pluginInfo["cardList"] as? Array ?? []
        let allPluginView = AllPluginViewController()
        allPluginView.pluginList = list
        self.navigationController?.pushViewController(allPluginView, animated: true)
    }
    
    func showDetailsAction(){
//        print("----")
        if errPlugins.count == 0 {
            let alert = UIAlertController.init(title: "提示", message: "没有错误配件", preferredStyle: .alert)
            let cancle = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
            alert.addAction(cancle)
            let window:UIWindow =  ((UIApplication.shared.delegate?.window)!)!
            window.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        let errPluginView = ErrPluginViewController()
        errPluginView.pluginList = errPlugins
        self.navigationController?.pushViewController(errPluginView, animated: true)
    }

}
