
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
        //1.初始化左边 右边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: "leftItemClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: "rightItemClick")
        
        let titleBtn = TitleButton()
        titleBtn.setTitle("summer " , forState: UIControlState.Normal)
        titleBtn.addTarget(self, action: "titleBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)

        navigationItem.titleView = titleBtn
    }
    
    func titleBtnClick(btn: TitleButton){
        btn.selected = !btn.selected
    }
    
    func leftItemClick(){
        print(__FUNCTION__)
    }
    
    func rightItemClick(){
        print(__FUNCTION__)
    }
}
