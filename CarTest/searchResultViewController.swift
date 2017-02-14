//
//  searchResultViewController.swift
//  CarTest
//
//  Created by Rongbin on 16/9/5.
//  Copyright © 2016年 com.xdy. All rights reserved.
//  查询结果页

import UIKit



class searchResultViewController: BaseViewController,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate {
    
    let addressLable = UILabel()//地址显示
    let locationLable = UILabel()//定位时间
    let gprsLable = UILabel()//gprs在线状态
    let vinLable = UILabel()//VIN配置状态  成功显示绿色，失败显示红色
    var _mapView: BMKMapView = BMKMapView()
    let _service = BMKLocationService.init()
    let config = Config.share
    var carLocationPoint = BMKPointAnnotation.init()
    var renLocationPoint = BMKPointAnnotation.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCarLocation()
        
        _service.startUserLocationService()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        _mapView.viewWillAppear()
        _mapView.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
        _service.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        _mapView.delegate = nil // 此处记得不用的时候需要置nil，否则影响内存的释放
        _service.delegate = nil
    }
    
    //MARK: - 主界面
    func setupMainUI(_ carInfo:[String:Any]){
        self.title = "查询结果"
        //地址
        addressLable.layer.cornerRadius = 5
        addressLable.backgroundColor = UIColor.init(red: 29/255.0, green: 32/255.0, blue: 37/255.0, alpha: 1)
        addressLable.textColor = UIColor.white
        addressLable.text = "查询中."
        addressLable.font = UIFont.systemFont(ofSize: 16)
        self.view.addSubview(addressLable)
        addressLable.anchorAndFillEdge(.Top, xPad: 20, yPad: 20, otherSize: 40)
        
        //定位时间
        locationLable.layer.cornerRadius = 5
        locationLable.backgroundColor = UIColor.init(red: 29/255.0, green: 32/255.0, blue: 37/255.0, alpha: 1)
        locationLable.textColor = UIColor.white
        locationLable.font = UIFont.systemFont(ofSize: 16)
        locationLable.text = " 定位时间：\(carInfo["upTime"] as! String)"
        self.view.addSubview(locationLable)
        locationLable.anchorAndFillEdge(.Top, xPad: 20, yPad: 70, otherSize: 40)
        
        //GPRS和VIN配置
//        let bgView1 = UIView.init()
//        self.view.addSubview(bgView1)
//        bgView1.backgroundColor = UIColor.red
        //bgView1.anchorAndFillEdge(.Top, xPad: 10, yPad: 110, otherSize: 60)
        
        gprsLable.layer.cornerRadius=5
        gprsLable.backgroundColor = UIColor.init(red: 29/255.0, green: 32/255.0, blue: 37/255.0, alpha: 1)
        gprsLable.text = "获取中."
        gprsLable.textColor = UIColor.white
        self.view.addSubview(gprsLable)
        
        gprsLable.align(Align.UnderMatchingLeft, relativeTo: locationLable, padding: 10, width: (self.view.bounds.size.width - 50)/2, height: 40)
        
        vinLable.layer.cornerRadius = 5
        vinLable.backgroundColor = UIColor.init(red: 29/255.0, green: 32/255.0, blue: 37/255.0, alpha: 1)
        vinLable.textColor = UIColor.white
        vinLable.text = "获取中."
        //bgView1.addSubview(gprsLable)
        self.view.addSubview(vinLable)
        
        vinLable.align(Align.ToTheRightCentered, relativeTo: gprsLable, padding: 10, width: (self.view.bounds.size.width - 50)/2, height: 40)
        
        self.view.addSubview(_mapView)
        _mapView.zoomLevel = 12
        _mapView.anchorAndFillEdge(.Top, xPad: 0, yPad: 180, otherSize: 220)
        
        //添加地图按钮
        let renLocationButton = UIButton.init()
        renLocationButton.addTarget(self, action: #selector(moveRenLocation), for: .touchUpInside)
        renLocationButton.setImage(UIImage.init(named: "btn_ren"), for: .normal)
        renLocationButton.setImage(UIImage.init(named: "btn_ren_ed"), for: .highlighted)
        _mapView.addSubview(renLocationButton)
        
        let carLocationButton = UIButton.init()
        carLocationButton.addTarget(self, action: #selector(moveCarLocation), for: .touchUpInside)
        carLocationButton.setImage(UIImage.init(named: "btn_car"), for: .normal)
        carLocationButton.setImage(UIImage.init(named: "btn_car_ed"), for: .highlighted)
        _mapView.addSubview(carLocationButton)
        
        renLocationButton.anchorInCorner(Corner.BottomLeft, xPad: 5, yPad: 10, width: 40, height: 40)
        carLocationButton.align(Align.ToTheRightCentered, relativeTo: renLocationButton, padding: 0, width: 40, height: 40)
        
        
        
        let buttonWidth:CGFloat = 300.0
        let buttonHeight:CGFloat = 40.0
        let buttonAlign:CGFloat = 5.0
        
        let button1 = UIButton()
        button1.setBackgroundImage(UIImage.init(named: "btn_bg"), for: UIControlState())
        button1.addTarget(self, action: #selector(goPlugin), for: .touchUpInside)
        button1.setTitle("零部件信息", for: UIControlState())
        self.view.addSubview(button1)
        button1.align(.UnderCentered, relativeTo: _mapView, padding: buttonAlign+5, width: buttonWidth, height: buttonHeight)
        
        let button2 = UIButton()
        button2.setBackgroundImage(UIImage.init(named: "btn_bg"), for: UIControlState())
        button2.addTarget(self, action: #selector(goCarInfo), for: .touchUpInside)
        button2.setTitle("车辆状态", for: UIControlState())
        self.view.addSubview(button2)
        button2.align(.UnderCentered, relativeTo: button1, padding: buttonAlign, width: buttonWidth, height: buttonHeight)
        
        let button3 = UIButton()
        button3.setBackgroundImage(UIImage.init(named: "btn_bg"), for: UIControlState())
        button3.setTitle("流量查询", for: UIControlState())
        button3.addTarget(self, action: #selector(goLiuLiang), for: .touchUpInside)
        self.view.addSubview(button3)
        button3.align(.UnderCentered, relativeTo: button2, padding: buttonAlign, width: buttonWidth, height: buttonHeight)
        
        let button4 = UIButton()
        button4.setBackgroundImage(UIImage.init(named: "btn_bg"), for: UIControlState())
        button4.setTitle("短信配置", for: UIControlState())
        button4.addTarget(self, action: #selector(goShortMessage), for: .touchUpInside)
        self.view.addSubview(button4)
        button4.align(.UnderCentered, relativeTo: button3, padding: buttonAlign, width: buttonWidth, height: buttonHeight)
        
    }
    
    //MARK: - 零部件信息
    func goPlugin(){
        let pluginView = PlugnInfoViewController()
        self.navigationController?.pushViewController(pluginView, animated: true)
    }
    
    //MARK: - 车辆状态
    func goCarInfo(){
        let pluginView = CarInfoViewController()
        self.navigationController?.pushViewController(pluginView, animated: true)
    }
    
    //MARK: - 流量配置
    func goLiuLiang(){
        let pluginView = LiLiangCfgViewController()
        self.navigationController?.pushViewController(pluginView, animated: true)
    }
    
    //MARK: - 短信配置
    func goShortMessage(){
        let pluginView = ShortMsgCfgViewController()
        self.navigationController?.pushViewController(pluginView, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - 车辆定位
    func loadCarLocation(){
        let parms = ["vinCode":config.vinCode as AnyObject,"token":config.token as AnyObject]
        
        let http = HttpRequest.sharedInstance
        let spinner = SwiftSpinner.show("查询中...")
        http.request(http.uri+"carPlace", parm: parms) { (isSuccess, result) in
            if isSuccess {
                spinner.title = "完成"
                let dic:Dictionary<String,AnyObject> = result as! Dictionary<String,AnyObject>
                self.queryAddress(dic)
                self.setupMainUI(dic)
                self.getGPRSStatus()
            }else{
                spinner.title = "网络超时，请重试"
            }
            spinner.animating = false
            spinner.delay(0.5, completion: { 
                let _ = SwiftSpinner.hide()
            })
        }
    }
    //获取gprs状态
    func getGPRSStatus() {
        
        let parms = ["vinCode":config.vinCode as AnyObject,"token":config.token as AnyObject]
        
        let http = HttpRequest.sharedInstance
        http.request(http.uri+"getStatus", parm: parms) { (isSuccess, result) in
            if isSuccess {
                let dic = result as! [String:Any]
                let onlineStatus = dic["onlineStatus"] as! Int
                let vinConfigStatus = dic["vinConfigStatus"] as! Int
                
                if onlineStatus == 1 {
                    self.gprsLable.text = " 在线"
                    self.gprsLable.textColor = UIColor.init(white: 1, alpha: 1)
                }else {
                    self.gprsLable.text = " 离线"
                    self.gprsLable.textColor = UIColor.init(white: 132/255.0, alpha: 1)
                }
                
                if vinConfigStatus == 1 {
                    self.vinLable.text = "VIN配置成功"
                    self.vinLable.textColor = UIColor.init(red: 8/255.0, green: 205/255.0, blue: 3/255.0, alpha: 1)
                }else {
                    self.vinLable.text = "VIN配置失败"
                    self.vinLable.textColor = UIColor.init(red: 196/255.0, green: 27/255.0, blue: 22/255.0, alpha: 1)
                }
            }
        }
    }
    
    func queryAddress(_ dic:[String:Any]) {
        
        let searcher = BMKGeoCodeSearch.init()
        searcher.delegate = self
        let carLocation = CLLocationCoordinate2D.init(latitude:Double(dic["lat"] as! String)!, longitude: Double(dic["lng"] as! String)!)
        let geo:BMKReverseGeoCodeOption = BMKReverseGeoCodeOption.init()
        
        geo.reverseGeoPoint = carLocation
        
        carLocationPoint.coordinate = carLocation
        _mapView.addAnnotation(carLocationPoint)
        
        if searcher.reverseGeoCode(geo) {
            print("逆编码发送成功")
        }else{
            print("逆编码发送失败")
        }
        
    }
    
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        let address:String = result.address as String
        addressLable.text = " \(address)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _mapView.viewWillDisappear()
        _mapView.delegate = nil // 不用时，置nil
    }
    //地图定位到车
    func moveCarLocation() {
        _mapView.setCenter(carLocationPoint.coordinate, animated: true)
    }
    //地图定位到人
    func moveRenLocation() {
        _mapView.setCenter(renLocationPoint.coordinate, animated: true)
    }
    
    //MARK: - 地图代理
    func didUpdate(_ userLocation: BMKUserLocation!) {
        renLocationPoint.coordinate = userLocation.location.coordinate
        _service.stopUserLocationService()
        
        _mapView.addAnnotation(renLocationPoint)
    }
    
    func didFailToLocateUserWithError(_ error: Error!) {
        print("定位失败："+error.localizedDescription)
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation.isKind(of: BMKPointAnnotation.self) {
           let pointView = BMKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "myAnnotation")
            if annotation.isEqual(carLocationPoint) {
                pointView?.image = UIImage.init(named: "carlocation")
            }
            
            if annotation.isEqual(renLocationPoint) {
                pointView?.image = UIImage.init(named: "renLocation")
            }
            return pointView
        }
        
        return nil
    }

}
