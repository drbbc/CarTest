//
//  ShortMsgCfgViewController.swift
//  CarTest
//
//  Created by Rongbin on 16/9/14.
//  Copyright © 2016年 com.xdy. All rights reserved.
//  短信配置

import UIKit

class ShortMsgCfgViewController: BaseViewController {

    let cf = Config.share
    let http = HttpRequest.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "短信配置"
        setupMainUI()
    }
    
    
    func setupMainUI() {
        let titleLable = CLable.init()
        titleLable.text = "   短信配置IP"
        self.view.addSubview(titleLable)
        titleLable.anchorAndFillEdge(.Top, xPad: 0, yPad: 10, otherSize: 40)
        
        let button1 = UIButton()
        button1.setBackgroundImage(UIImage.init(named: "btn_bg"), for: UIControlState())
        button1.addTarget(self, action: #selector(cfgIpAction(_:)), for: .touchUpInside)
        button1.setTitle("配置", for: .normal)
        self.view.addSubview(button1)
        button1.align(.UnderMatchingLeft, relativeTo: titleLable, padding: 10, width: (self.view.bounds.width-30)/2, height: 40,offset: 10)
        
        let button2 = UIButton()
        button2.setBackgroundImage(UIImage.init(named: "btn_bg"), for: .normal)
        button2.addTarget(self, action: #selector(queryIpAction(_:)), for: .touchUpInside)
        button2.setTitle("查询", for: .normal)
        self.view.addSubview(button2)
        button2.align(.ToTheRightCentered, relativeTo: button1, padding: 10, width: (self.view.bounds.width-30)/2, height: 40)
        
        
        let titleLable1 = CLable.init()
        titleLable1.text = "   短信配置VIN"
        self.view.addSubview(titleLable1)
        titleLable1.anchorAndFillEdge(.Top, xPad: 0, yPad: 120, otherSize: 40)
        
        let button3 = UIButton()
        button3.setBackgroundImage(UIImage.init(named: "btn_bg"), for: UIControlState())
        button3.addTarget(self, action: #selector(cfgVinAction(_:)), for: .touchUpInside)
        button3.setTitle("配置", for: .normal)
        self.view.addSubview(button3)
        button3.align(.UnderMatchingLeft, relativeTo: titleLable1, padding: 10, width: (self.view.bounds.width-30)/2, height: 40,offset: 10)
        
        let button4 = UIButton()
        button4.setBackgroundImage(UIImage.init(named: "btn_bg"), for: UIControlState())
        button4.addTarget(self, action: #selector(queryVinAction(_:)), for: .touchUpInside)
        button4.setTitle("查询", for: .normal)
        self.view.addSubview(button4)
        button4.align(.ToTheRightCentered, relativeTo: button3, padding: 10, width: (self.view.bounds.width-30)/2, height: 40)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 按钮事件处理
    func queryIpAction(_ button:UIButton){
        queryRequest("2")
    }
    
    func queryVinAction(_ button:UIButton){
        queryRequest("1")
    }
    
    func cfgIpAction(_ button:UIButton){
        
        cfgRequest("2")
    }
    
    func cfgVinAction(_ button:UIButton){
        cfgRequest("1")
    }
    
    //配置
    func cfgRequest(_ flag:String){
        let parms = ["vinCode":cf.vinCode as AnyObject,"token":cf.token as AnyObject]
        let _ = SwiftSpinner.show("配置中")
        http.request(http.uri+"vinConfig", parm: parms) { (isSuccess, result) in
            SwiftSpinner.hide()
            self.cf.alertView(result["msg"] as? String ?? "配置失败")
        }
    }
    
    func queryRequest(_ flag:String){
        let parms = ["vinCode":cf.vinCode as AnyObject,"token":cf.token as AnyObject]
        let _ = SwiftSpinner.show("查询中")
        http.request(http.uri+"vinConfig", parm: parms) { (isSuccess, result) in
            SwiftSpinner.hide()
            self.cf.alertView(result["msg"] as? String ?? "查询失败")
        }
    }

}
