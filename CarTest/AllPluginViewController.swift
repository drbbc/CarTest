//
//  AllPluginViewController.swift
//  CarTest
//
//  Created by Rongbin on 16/9/28.
//  Copyright © 2016年 com.xdy. All rights reserved.
// 全部配件

import UIKit

class AllPluginViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var pluginList:Array<[String:Any]> = Array.init()
    let _tableView = UITableView()
    var showMore:Array<Bool> = Array.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "全部零部件信息"
        for i in 0...pluginList.count {
           showMore.insert(false, at: i)
        }
        setupMainUI()
    }
    
    func setupMainUI(){
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.separatorStyle = .none
        _tableView.backgroundColor = UIColor.clear
        self.view.addSubview(_tableView)
        _tableView.fillSuperview(left: 0, right: 0, top: 0, bottom: 0)
        _tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - tableView 代理
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CusTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CusTableViewCell ??  CusTableViewCell.init(style: .default, reuseIdentifier: "Cell")
        cell.showMore = showMore[indexPath.row]
        cell.showMoreButton.tag = indexPath.row+10
        cell.showMoreButton.addTarget(self, action: #selector(showMoreAction(_:)), for: .touchUpInside)
        
        let dic:[String:Any] = pluginList[indexPath.row]
        cell.dic = dic
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pluginList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if showMore[indexPath.row] {
            return 40+120
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func showMoreAction(_ button:UIButton){
        //print("showMore\(button.tag)")
        let index = button.tag-10
        showMore[index] = !showMore[index]
        _tableView.reloadData()
    }
}
