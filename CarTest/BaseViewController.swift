//
//  BaseViewController.swift
//  CarTest
//
//  Created by Rongbin on 16/8/29.
//  Copyright © 2016年 com.xdy. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let bgImg = UIImageView.init(frame: self.view.bounds)
        bgImg.image = UIImage.init(named: "bg")
        bgImg.isUserInteractionEnabled = true
        self.view.addSubview(bgImg)
        // Do any additional setup after loading the view.
        
        let btn1=UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 44))
        btn1.setImage(UIImage.init(named: "back"), for: UIControlState())
        btn1.addTarget(self, action: #selector(back), for: .touchUpInside)
        let item2=UIBarButtonItem(customView: btn1)
        self.navigationItem.leftBarButtonItem=item2
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 29/255.0, green: 32/255.0, blue: 37/255.0, alpha: 1)
        //self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 29/255.0, green: 32/255.0, blue: 37/255.0, alpha: 1)
        
    }
    
    func back(){
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}
