//
//  MainViewController.swift
//  CarTest
//
//  Created by Rongbin on 16/8/30.
//  Copyright © 2016年 com.xdy. All rights reserved.
//

import UIKit
import QRCodeReader

class MainViewController: BaseViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var dataList:Array<String> = []
    let _tableView = UITableView()
    let searchBar = CustomSearchBar()
    let cfg = Config.share
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 创建主界面
    func setupMainUI(){
        
        let topBgView = UIView.init()
        topBgView.backgroundColor = UIColor.init(white: 1, alpha: 0.1)
        self.view.addSubview(topBgView)
        
        topBgView.anchorAndFillEdge(.Top, xPad: 0, yPad: 24, otherSize: 120)
//      
        //let ani = UIActivityIndicatorView
        let titleLable = UILabel.init()
        titleLable.text = "添加车辆VIN码"
        titleLable.textColor = UIColor.white
//        titleLable.backgroundColor = UIColor.redColor()
        titleLable.font = UIFont.systemFont(ofSize: 18)
        topBgView.addSubview(titleLable)
        titleLable.anchorAndFillEdge(Edge.Top, xPad: 20, yPad: 10, otherSize: 30)
//
        let line1 = UIView.init()
        line1.backgroundColor = UIColor.white
        topBgView.addSubview(line1)
        line1.alignAndFillWidth(align: Align.UnderCentered, relativeTo: titleLable, padding: 10, height: 0.5)
        
        let qrButton = UIButton.init()
        qrButton.addTarget(self, action: #selector(qrAction), for: .touchUpInside)
        qrButton.setImage(UIImage.init(named: "btn_sao"), for: UIControlState())
        topBgView.addSubview(qrButton)
        qrButton.align(.UnderMatchingRight, relativeTo: line1, padding: 10, width: 40, height: 40)
    

        
        searchBar.placeholder = "请输入VIN号后六位"
        searchBar.barStyle = UIBarStyle.black
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
//        searchBar.tintColor = UIColor.red

        searchBar.delegate = self

        searchBar.subviews[0].subviews[0].removeFromSuperview()
        topBgView.addSubview(searchBar)
        
        searchBar.alignAndFillWidth(align: .ToTheLeftCentered, relativeTo: qrButton, padding: 10, height: 40)
        
        let searchButton = DiyButton.init()
        searchButton.layer.cornerRadius = 5
        searchButton.backgroundColor = UIColor.init(red: 28/255.0, green: 154/255.0, blue: 212/255.0, alpha: 1)
        searchButton.setTitle("查询", for: UIControlState())
        searchButton.addTarget(self, action: #selector(shearchAction), for: .touchUpInside)
        self.view.addSubview(searchButton)
        searchButton.alignAndFillWidth(align: .UnderCentered, relativeTo: topBgView, padding: 10, height: 40)
        
        let useNoticeButton = DiyButton.init()
        useNoticeButton.layer.cornerRadius=5
        useNoticeButton.backgroundColor = searchButton.backgroundColor
        useNoticeButton.setTitle("使用说明", for: UIControlState())
        self.view.addSubview(useNoticeButton)
        useNoticeButton.alignAndFillWidth(align: .UnderCentered, relativeTo: searchButton, padding: 10, height: 40)
        
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.separatorColor = UIColor.init(white: 0.2, alpha: 0.8)
        _tableView.backgroundColor = UIColor.clear
        _tableView.frame = CGRect(x: 20, y: topBgView.bounds.origin.y+150, width: searchBar.bounds.size.width, height: 0)
        self.view.addSubview(_tableView)
//        _tableView.alignAndFillWidth(align: .UnderCentered, relativeTo: searchBar, padding: 10, height: 0)
    }
    
    func shearchAction(){
        if cfg.vinCode != "",searchBar.text == cfg.vinCode {
            let searchView = searchResultViewController();
            self.navigationController?.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(searchView, animated: true)
        }else{
            cfg.alertView("Vin号不正确")
        }
        
    }
    
    //MARK: - 搜索条代理
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print(searchText)
        if searchText.lengthOfBytes(using: String.Encoding.ascii) >= 5
        {
            //let aview = UIActivityIndicatorView.init()
            
            let http = HttpRequest.sharedInstance
            let parms  = ["token":cfg.token,"vinCode":searchText]
            let spinner =   SwiftSpinner.show("查询中...")
            http.request(http.uri+"getCarVinCode", parm: parms as [String : AnyObject], block: { (isSuccess, result) in
                if isSuccess {
                    spinner.title = "查询成功"
                    let dic:Dictionary<String,AnyObject>  = result as! Dictionary<String,AnyObject>
                   
                    let list:Array<String> = dic["vinCodes"] as! Array<String>
                    
                    self.dataList = list
                    self.showTableView()
                }else {
                    //spinner.title = "查询失败"
                    self.hideTableView()
                }
                
                spinner.delay(0.5, completion: {
                    let _ = SwiftSpinner.hide()
                })
            })
        }
    }
    
    //MARK: - tableView 代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell()
        }
        cell?.backgroundColor = UIColor.init(white: 0.3, alpha: 0.8)
        cell?.textLabel?.text = dataList[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vinCode = dataList[indexPath.row]
        searchBar.text = vinCode
        cfg.vinCode = vinCode
        hideTableView()
    }
    
    //显示下拉列表
    func showTableView() {
        let height:CGFloat = CGFloat(dataList.count * 40+10)
        self._tableView.reloadData()
        UIView.animate(withDuration: 1) { 
            self._tableView.bounds.size.height = height
        }
    }
    //隐藏下拉列表
    func hideTableView(){
        UIView.animate(withDuration: 0.5) {
            self._tableView.bounds.size.height = 0
        }
    }
    
    func qrAction(){
        let qrView = QRViewController()
        qrView.qrUrlBlock = { url in
            
            let vin:String = url! as String
            print(vin)
            let predicate =  NSPredicate(format: "SELF MATCHES %@" ,"^LJ[A-Z0-9]{15}")
            if predicate.evaluate(with: vin) {
                self.cfg.vinCode = vin
                self.searchBar.text = self.cfg.vinCode
            }else{
                self.cfg.alertView("请扫描Vin生成的二维码")
            }
        }
        self.navigationController?.pushViewController(qrView, animated: true)
    }
    
}
