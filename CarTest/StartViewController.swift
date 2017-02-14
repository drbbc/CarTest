//
//  StartViewController.swift
//  CarTest
//
//  Created by Rongbin on 16/8/29.
//  Copyright © 2016年 com.xdy. All rights reserved.
//  启动页

import UIKit

class StartViewController: BaseViewController,UITextFieldDelegate {
    var yanzheng:DiyButton?
    var mobileTF:UITextField = UITextField.init()
    var codeTF:UITextField = UITextField.init()
    let lable = UILabel.init()
    var timeOut = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nQAmqjcC3FHYG9W7m4lncQ==,2016-09-18 14:33:21
        let config = Config.share
        config.token = "nQAmqjcC3FHYG9W7m4lncQ==,2016-09-18 14:33:21"
        
        setupLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         //self.navigationController!.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: - 界面布局
    
    func setupLogin() {
        
        let logo = UIImageView.init(frame: CGRect(x: (self.view.frame.size.width-121.5)/2, y: (self.view.frame.size.height-405)/2, width: 121.5, height: 105.5))
        logo.image = UIImage.init(named: "icon")
        self.view.addSubview(logo)
        
        
        lable.text = "车辆信息审核系统"
        lable.textAlignment = NSTextAlignment.center
        lable.textColor = UIColor.init(red: 30/255.0, green: 154/255.0, blue: 216/255.0, alpha: 1)
        lable.font = UIFont.systemFont(ofSize: 18)
        self.view.addSubview(lable)
        lable.align(.UnderCentered, relativeTo: logo, padding: 20, width: 180, height: 40)
        
        
        let inputBgView = UIView.init()
        inputBgView.layer.cornerRadius = 5
        inputBgView.layer.borderColor = UIColor.white.cgColor
        inputBgView.layer.borderWidth = 1
        inputBgView.isUserInteractionEnabled = true
        self.view .addSubview(inputBgView)
        inputBgView.alignAndFillWidth(align: .UnderCentered, relativeTo: lable, padding: 20, height: 80)
        //inputBgView.anchorInCenter(width: self.view.frame.width-40, height: 80)
        
        let img = UIImageView.init()
        img.image = UIImage.init(named: "icon_phone")
        
        inputBgView.addSubview(img)
        
//        img.anchorToEdge(Edge.Top, padding: 5, width: 27.5, height: 29.5)
        img.anchorInCorner(Corner.TopLeft, xPad: 5, yPad: 5, width: 27.5, height: 29.5)
        
        let line1 = UIView.init()
        line1.backgroundColor = UIColor.white
        
        inputBgView.addSubview(line1)
        
        line1.align(Align.ToTheRightMatchingTop, relativeTo: img, padding: 5, width: 1, height: 30)
        
        mobileTF = UITextField.init()
        mobileTF.textColor = UIColor.white
        //mobileTF.text = "15801061765"
        mobileTF.text = "15611189213"
        mobileTF.keyboardType = UIKeyboardType.numberPad
        mobileTF.attributedPlaceholder = NSAttributedString.init(string: "请输入手机号", attributes: [NSForegroundColorAttributeName:UIColor.init(white: 1, alpha: 0.4)])
        inputBgView.addSubview(mobileTF)
        
        mobileTF.alignAndFillWidth(align: Align.ToTheRightMatchingTop, relativeTo: line1, padding: 5, height: 30)
        
        let line2 = UIView.init()
        line2.backgroundColor = UIColor.white
        inputBgView.addSubview(line2)
        
        line2.alignAndFillWidth(align: Align.UnderCentered, relativeTo: mobileTF, padding: 5, height: 1)
        
        let img2 = UIImageView.init()
        img2.image = UIImage.init(named: "icon_code")
        inputBgView.addSubview(img2)
        img2.anchorInCorner(Corner.BottomLeft, xPad: 5, yPad: 5, width: 27.5, height: 29.5)
        
        let line3 = UIView.init()
        line3.backgroundColor = UIColor.white
        inputBgView.addSubview(line3)
        line3.align(Align.ToTheRightCentered, relativeTo: img2, padding: 5, width: 1, height: 30)
        
        yanzheng = DiyButton.init()
        yanzheng!.setTitle("获取验证码", for: UIControlState())
        yanzheng!.layer.cornerRadius = 4
        yanzheng!.addTarget(self, action:#selector(getCode), for: .touchUpInside)
        yanzheng!.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        yanzheng!.backgroundColor = UIColor.init(red: 42/255.0, green: 126/255.0, blue: 163/255.0, alpha: 1)
        inputBgView.addSubview(yanzheng!)
        yanzheng!.anchorInCorner(Corner.BottomRight, xPad: 4, yPad: 2, width: 80, height: 36)
        
//        let textField = UITextField.init()
        codeTF.textColor = UIColor.white
        codeTF.keyboardType = UIKeyboardType.numberPad
        codeTF.attributedPlaceholder = NSAttributedString.init(string: "验证码", attributes: [NSForegroundColorAttributeName:UIColor.init(white: 1, alpha: 0.4)])
        inputBgView.addSubview(codeTF)
        
        codeTF.alignBetweenHorizontal(align: Align.ToTheRightCentered, primaryView: line3, secondaryView: yanzheng!, padding: 5, height: 30)
        
        let tijiao = DiyButton.init()
        tijiao.backgroundColor = UIColor.init(red: 28/255.0, green: 154/255.0, blue: 212/255.0, alpha: 1)
        tijiao.layer.cornerRadius = 5
        tijiao.addTarget(self, action:#selector(tijiaoAction), for: .touchUpInside)
        tijiao.setTitle("提交", for: UIControlState())
        self.view.addSubview(tijiao)
        
        tijiao.alignAndFillWidth(align: Align.UnderCentered, relativeTo: inputBgView, padding: 20, height: 40)
        
    }

    // MARK: - 提交按钮事件
    func tijiaoAction() {
        //self.jumpMain()
        
        let requestHttp = HttpRequest.sharedInstance
        var mobile = ""
        if (mobileTF.text == nil){
            return
        }else{
            mobile = (mobileTF.text)!
        }
        var code = ""
        if (codeTF.text == nil){
            return
        }else{
            code = (codeTF.text)!
        }
        
       let spinner = SwiftSpinner.show("登录中...")
        requestHttp.request(requestHttp.uri+"login", parm: ["mobile":mobile as AnyObject,"code":code as AnyObject]) { (isSuccess, returnResult) in
            debugPrint(returnResult)
            let dic:Dictionary<String,Any> = returnResult as! Dictionary<String, Any>
            if isSuccess {
                spinner.title = "登录成功"
                let token:String = dic["token"] as! String
                let isAdminStr:String = dic["isAdmin"] as! String
                var isAdmin:Bool = false
                if  token != "" {
                print("存入的token:\(token)")
                let ud = UserDefaults.standard
                ud.set(token, forKey: "user_token")
                if isAdminStr == "1" {
                    ud.set(true, forKey: "isAdmin")
                    isAdmin = true
                }else{
                    ud.set(false, forKey: "isAdmin")
                }
                let config:Config = Config.share
                config.token = token
                config.isAdmin = isAdmin
                config.mobile = mobile
                UserDefaults.standard.synchronize()
                
                let tk = ud.string(forKey: "user_token")
                print("----tk:\(tk)")
                    self.jumpMain()}
                else{
                   print(dic["token"])
                }
            } else {
                spinner.title = "登录失败"
                
            }
            spinner.delay(1, completion: {
               let _ = SwiftSpinner.hide()
            })
        }
    }
    
    // MARK: 跳转到首页
    func jumpMain(){
        let mainView = MainViewController.init()
        let nav = UINavigationController.init(rootViewController: mainView)
//        nav.navigationBar.tintColor = UIColor.init(red: 29/255.0, green: 32/255.0, blue: 37/255.0, alpha: 1)
//        nav.navigationBar.isTranslucent = false
//        UINavigationBar.appearance().tintColor = UIColor.init(red: 29/255.0, green: 32/255.0, blue: 37/255.0, alpha: 1)
//        UINavigationBar.appearance().barTintColor = UIColor.init(red: 29/255.0, green: 32/255.0, blue: 37/255.0, alpha: 1) //修改导航栏背景色
//        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white] //为导航栏设置字体颜色等
        
        UIApplication.shared.keyWindow?.rootViewController = nav
    }
    
    // MARK: - 获取手机验证码
    func getCode() {
        let httpReq = HttpRequest.sharedInstance
        let spinner = SwiftSpinner.show("获取中...")
        httpReq.request(httpReq.uri+"getCode", parm: ["mobile":"\((mobileTF.text)!)" as AnyObject]) { (isSuccess, returnResult) in
            if (isSuccess){
                self.timeOut = 60
                spinner.title = "发送成功"
                spinner.animating = false
                self.perform(#selector(self.codeTimeOut), with: nil, afterDelay: 1)
                //print(returnResult)
            }else{
                spinner.title = "获取失败"
                spinner.animating = false
                //print(returnResult)
            }
            
            spinner.delay(0.4, completion: {
                let _ = SwiftSpinner.hide()
            })
        }
    }
    //MARK: 倒计时
    func codeTimeOut(){
        if timeOut > 0 {
            yanzheng?.isEnabled = false
            timeOut = timeOut-1
            yanzheng?.setTitle(String.init(stringInterpolationSegment: timeOut), for: .normal)
            self.perform(#selector(codeTimeOut), with: nil, afterDelay: 1)
        }else{
            yanzheng?.isEnabled = true
            yanzheng?.setTitle("获取验证码", for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
