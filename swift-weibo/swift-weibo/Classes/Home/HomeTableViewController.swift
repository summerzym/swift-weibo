
//
//  HomeTableViewController.swift
//  swift-weibo
//
//  Created by SummerZhao on 16/5/10.
//  Copyright © 2016年 yunmei. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.如果没有登录，就设置未登录界面信息
        if !userLogin{
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        //2.初始化导航条
        setUpNav()
    }
    
    private func setUpNav(){
        //1.左边按钮
//        navigationItem.leftBarButtonItem = createBarButtonItem("navigationbar_friendattention", target: self, action: "leftItemClick")
//        //2.右边按钮
//        navigationItem.rightBarButtonItem = createBarButtonItem("navigationbar_pop", target: self, action: "rightItemClick")

        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: "leftItemClick")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: "rightItemClick")
    }
    
    func leftItemClick(){
        print(__FUNCTION__)
    }
    
    func rightItemClick(){
        print(__FUNCTION__)
    }
    
//    private func createBarButtonItem(imageName:String, target:AnyObject?, action:Selector) -> UIBarButtonItem{
//        let btn = UIButton()
//        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
//        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
//        btn.sizeToFit()
//        btn.addTarget(target, action:action, forControlEvents: UIControlEvents.TouchUpInside)
//        return UIBarButtonItem(customView: btn)
//    }
}
