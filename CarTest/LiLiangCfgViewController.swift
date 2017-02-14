//
//  LiLiangCfgViewController.swift
//  CarTest
//
//  Created by Rongbin on 16/9/14.
//  Copyright © 2016年 com.xdy. All rights reserved.
//  流量配置

import UIKit

class LiLiangCfgViewController: BaseViewController {

    let cf = Config.share
    var dic:[String:Any] = Dictionary.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "流量查询"
        loadData()
        //setupMainUI()
    }
    func setupMainUI() {
        let titleLength:CGFloat = 120
        var is3Gon = false
        
        let titleLable = CLable.init()
        titleLable.isWhiteBg = true
        titleLable.text = "   VIN"
        self.view.addSubview(titleLable)
        titleLable.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 5, width: titleLength, height: 40)
        
        let conLable1 = CLable()
        conLable1.isWhiteBg = true
        conLable1.text = cf.vinCode
        self.view.addSubview(conLable1)
        conLable1.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: titleLable, padding: 0, height: 40)
        
        //
        let titleLable2 = CLable.init()
        //titleLable2.isWhiteBg = true
        titleLable2.text = "   流量使用状态"
        self.view.addSubview(titleLable2)
        titleLable2.align(.UnderMatchingLeft, relativeTo: titleLable, padding: 0, width: titleLength, height: 40)
        
        let conLable2 = CLable()
        //conLable2.isWhiteBg = true
        let isColse3G = dic["isClose3g"] as? Int ?? 0
        if  isColse3G == 1 {
            conLable2.text = "启用"
            is3Gon = true
        } else {
            conLable2.text = "禁用"
        }
        self.view.addSubview(conLable2)
        conLable2.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: titleLable2, padding: 0, height: 40)
        
        if is3Gon {
            //
            let titleLable3 = CLable.init()
            titleLable3.isWhiteBg = true
            titleLable3.text = "   套餐状态"
            self.view.addSubview(titleLable3)
            titleLable3.align(.UnderMatchingLeft, relativeTo: titleLable2, padding: 0, width: titleLength, height: 40)
            
            let conLable3 = CLable()
            conLable3.isWhiteBg = true
            let planStatus:Int = dic["planStatus"] as? Int ?? 0
            switch planStatus {
            case 1:
                conLable3.text = "套餐一"
                break
            case 2:
                conLable3.text = "套餐二"
                break
            default:
                conLable3.text = "没有套餐"
                break
            }
            self.view.addSubview(conLable3)
            conLable3.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: titleLable3, padding: 0, height: 40)
            
            let titleLable4 = CLable.init()
            //titleLable4.isWhiteBg = true
            titleLable4.text = "   套餐流量阀值"
            self.view.addSubview(titleLable4)
            titleLable4.align(.UnderMatchingLeft, relativeTo: titleLable3, padding: 0, width: titleLength, height: 40)
            
            let conLable4 = CLable()
            //conLable4.isWhiteBg = true
            let flowLimit:Int = dic["flowLimit"] as? Int ?? 0
            conLable4.text = "\(flowLimit) M"
            self.view.addSubview(conLable4)
            conLable4.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: titleLable4, padding: 0, height: 40)
            
            let titleLable5 = CLable.init()
            titleLable5.isWhiteBg = true
            titleLable5.text = "   套餐流量阀值"
            self.view.addSubview(titleLable5)
            titleLable5.align(.UnderMatchingLeft, relativeTo: titleLable4, padding: 0, width: titleLength, height: 40)
            
            let conLable5 = CLable()
            conLable5.isWhiteBg = true
            let bytesCnt:Int = dic["bytesCnt"] as? Int ?? 0
            conLable5.text = "\(bytesCnt)KB"
            self.view.addSubview(conLable5)
            conLable5.alignAndFillWidth(align: Align.ToTheRightCentered, relativeTo: titleLable5, padding: 0, height: 40)
        }
        
    }
    
    func setNoDataUI(){
        
    }
    
    func loadData(){
        let parms = ["vin":cf.vinCode as AnyObject,"token":cf.token as AnyObject]
        let http = HttpRequest.sharedInstance
        let spinner = SwiftSpinner.show("加载中")
        http.requestNoData(http.liuliangUri+"queryFlowByVin", parm: parms) { (isSuccess, result) in
            if isSuccess {
                spinner.title = "成功"
                let json:JSON = result as! JSON
                let flag:Int = json["flag"].intValue
                if flag==1 {
                self.dic = json["result"].rawDictionary
                self.setupMainUI()
                }else{
                    spinner.title = json["msg"].stringValue
                    self.setNoDataUI()
                }
                //LJU70W1ZXGG081250
            }else{
                spinner.title = "失败"
                self.setNoDataUI()
            }
            
            spinner.delay(0.5, completion: { 
                SwiftSpinner.hide()
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
