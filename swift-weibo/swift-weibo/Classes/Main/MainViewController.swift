//
//  MainViewController.swift
//  swift-weibo
//
//  Created by SummerZhao on 16/5/10.
//  Copyright © 2016年 yunmei. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 添加子控制器
        addChildViewControllers()
    }
    
    /**
     添加所有子控制
     */
    func addChildViewControllers() {
        
        let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        if let jsonPath =  path{
            let jsonData = NSData(contentsOfFile: jsonPath)
            
            do{
                let dictArr = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
                
                print(dictArr)
                
                //在swift中， 如果需要遍历一个数组，必须明确数据的类型
                for dict in dictArr as! [[String: String]]{
                    //字典的返回值是可选类型
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
                }
            }catch{
                print(error)
                addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
                addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
                addChildViewController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
                addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
            }
        }
    }
    
    /**
     初始化子控制器
     :param: childController 需要初始化的子控制器
     :param: title           初始化的标题
     :param: imageName       初始化的图片
     */
     //    func addChildViewController(childController: UIViewController, title:String, imageName:String) {
    func addChildViewController(childControllerName: String, title:String, imageName:String) {
        
        //        print(childController)
        // 0.动态获取命名空间
        let namespace = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
        print(namespace)
        
        // 告诉编译器暂时就是AnyClass
        let clsName = namespace + "." + childControllerName
        
        let cls:AnyClass = NSClassFromString(clsName)!
        print(cls)
        // 告诉编译器真实类型是UIViewController
        let vcCls = cls as! UITableViewController.Type
        // 实例化控制器
        let vc = vcCls.init()
        
        // 从内像外设置, nav和tabbar都有
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        // 注意: Xocde7之前只有文字有效果, 还需要设置图片渲染模式
        tabBar.tintColor = UIColor.orangeColor()
        
        // 2.创建导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        
        // 3.添加控制器到tabbarVC
        addChildViewController(nav)
        
    }
}
