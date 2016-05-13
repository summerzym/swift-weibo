//
//  HomeTableViewController.swift
//  XMGWB
//
//  Created by 李南江 on 15/9/6.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if !userLogin{
            
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
        }
        // 初始化导航条按钮
        setupNavgationItem()
        
    }
    
    func letBtnClick()
    {
        print(__FUNCTION__);
    }
    func rightBtnClick()
    {
        print(__FUNCTION__);
    }
    
    // MARK: - 内部控制方法
    /**
    初始化导航条按钮
    */
    private func setupNavgationItem()
    {
        // 1.添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: "letBtnClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: "rightBtnClick")
        
        // 2.添加标题按钮
        let titleBtn = TitleButton()
        titleBtn.setTitle("极客江南 ", forState: UIControlState.Normal)
        titleBtn.sizeToFit()
        titleBtn.addTarget(self, action: "titleBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
        
    }
    
    /**
     监听标题按钮点击
     
     :param: btn 标题按钮
     */
    func titleBtnClick(btn: TitleButton)
    {
        // 1.设置按钮状态
        btn.selected = !btn.selected
        
        // 2.创建Storyoard
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        
        // 3.设置转场代理, 告诉系统谁来负责转场
        vc.transitioningDelegate = self
        // 4.设置转场模式
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
}

extension HomeTableViewController: UIViewControllerTransitioningDelegate
{
    // 返回负责转场的控制器对象
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        
        return PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
}
