//
//  BaseTableViewController.swift
//  swift-weibo
//
//  Created by SummerZhao on 16/5/11.
//  Copyright © 2016年 yunmei. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController,VistorViewDelegate {

    var userLogin = false
    var visitorView:VisitorView?
    override func loadView() {
        userLogin ? super.loadView() : setUpVisitorView()
    }
    
    //创建访客试图
    private func setUpVisitorView(){
        //初始化未登录界面
        visitorView = VisitorView()
        visitorView?.delegate = self
        view = visitorView
        
        //2.设置导航条未登录按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "registerBtnWillClick")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "loginBtnWillClick")
    }
    
    func loginBtnWillClick() {
        print(__FUNCTION__)
    }
    
    func registerBtnWillClick() {
        print(__FUNCTION__)
    }
}
