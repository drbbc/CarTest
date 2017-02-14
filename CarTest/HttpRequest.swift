//
//  HttpRequest.swift
//  CarTest
//
//  Created by Rongbin on 16/8/31.
//  Copyright © 2016年 com.xdy. All rights reserved.
//  网络请求处理类

import UIKit
import Alamofire


class HttpRequest: NSObject {
    let uri:String = "http://58.58.205.18/test_app/"
    let liuliangUri = "http://vis.evcar.com/sim/api/"
    
    static let sharedInstance = HttpRequest()
    fileprivate override init(){}
    
    func request(_ url:String,parm:[String: AnyObject],block:@escaping (_ isSuccess:Bool,_ returnResult:AnyObject)->Void){
        //let requestUrl = self.uri+url
        
        let data : Data! = try? JSONSerialization.data(withJSONObject: parm, options: [])
            //NSData转换成NSString打印输出
        let str = NSString(data:data!, encoding: String.Encoding.utf8.rawValue) as! String
        let parms:Parameters = ["data":"\(str)"]
        
        let requrl = url+"?data=\(str)"
        print("请求的url:\(requrl)")
        doRequest(url, parm: parms) { (isSuccess, result) in
            
            if isSuccess {
                let json = result as! JSON
                if self.checkState(json:json) {
                    block(true,json["data"].dictionaryObject as AnyObject)
                } else {
                    block(false,json["data"].dictionaryObject as AnyObject)
                }
            } else {
                block(isSuccess,result)
            }
        }
    }
    
    func requestNoData(_ url:String,parm:[String: AnyObject],block:@escaping (_ isSuccess:Bool,_ returnResult:AnyObject)->Void){
        doRequest(url, parm: parm) { (isSuccess, result) in
            block(isSuccess,result)
        }
    }
    
    func doRequest(_ url:String,parm:[String: Any],block:@escaping (_ isSuccess:Bool,_ returnResult:AnyObject)->Void){
        Alamofire.request(url,parameters:parm).response{
            response in
            var status = 0
            if response.response != nil {
                status = response.response!.statusCode
            }
            print("http code:\(status)")
            switch (status){
            case 200:
                let json = JSON(data: response.data!)
                print("返回的json：\(json)")
                block(true,json as AnyObject)
                break
            case 500,502,503,504:
                block(false,["msg":"内部服务器错误 \(status)"] as AnyObject)
                break
            case 404:
                block(false,["msg":"404错误"] as AnyObject)
                break
            default:
                block(false,["msg":"网络错误"] as AnyObject)
                break
            }
        }
    }
    
    //MARK: - 检测返回状态是否正常
    func checkState(json:JSON) -> Bool {
        var rt:Bool = false
        let state = json["state"].stringValue
        if state != "" {
            if state == "1" {
                rt = true
            }else if state == "2" {//登录超时或没有登录
                goLoginView()
            }
        }
        return rt
    }
    
    func goLoginView(){
        let startView:UIViewController = StartViewController();
        let navView = UINavigationController.init(rootViewController: startView)
        UIApplication.shared.keyWindow?.rootViewController = navView
    }
    
    func dataConvert(data:Data) -> NSDictionary {
        return NSDictionary()
    }
    
    
    func login() -> Bool {
        var valid = false
        
        let ud = UserDefaults.standard
        let token = ud.object(forKey: "user_token") as? String
        let isAdmin = ud.object(forKey: "isAdmin") as? Bool
        print(token)
        if (token != nil && token != "") {
            let arr = token?.components(separatedBy: ",")
            let timeStr = arr?[1]
            
            let now = Date.init()
            let format  = DateFormatter.init()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let before = format.date(from: timeStr!)
            let before1 = before?.addingTimeInterval(60*60*24)
            print("-----\(now)-----\(before)------\(before1)")
            
            if before1! < now {
                print("登录超时")
            }else{
                let config = Config.share
                config.token = token!
                config.isAdmin = isAdmin!
                valid = true
            }
        }
        return valid
    }
    
    
    
}
