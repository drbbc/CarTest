//
//  Config.swift
//  CarTest
//
//  Created by Rongbin on 16/8/31.
//  Copyright © 2016年 com.xdy. All rights reserved.
//

import UIKit

class Config: NSObject {
    
    static let share = Config()
    fileprivate override init(){}
    //百度Key
    let BaiduKey:String  = "7KUB6BQGO4C2HKXWKun2TYaimSvOEvR3"
    var token:String = ""
    var isAdmin:Bool = false
    var tokenValid:Bool = false
    var mobile:String = ""//当前登录账号
    
    //当前车的vin号
    var vinCode:String = ""
    
    let errMessage = "网络超时，请重试"
    
    func getDateStr(_ timeStr:Any) -> String {
        let outTimeStr = timeStr as? String
        let strArr = outTimeStr?.components(separatedBy: " ")
        return strArr?[0] ?? ""
    }
    
    func alertView(_ msg:String){
        let alert = UIAlertController.init(title: "提示", message: msg, preferredStyle: .alert)
        let cancle = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
        alert.addAction(cancle)
        let window:UIWindow =  ((UIApplication.shared.delegate?.window)!)!
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
