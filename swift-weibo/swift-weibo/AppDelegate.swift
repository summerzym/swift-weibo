//
//  AppDelegate.swift
//  swift-weibo
//
//  Created by SummerZhao on 16/5/9.
//  Copyright © 2016年 yunmei. All rights reserved.
//

import UIKit
import AFNetworking

/// 视图控制器切换通知字符串
let XMGRootViewControllerSwitchNotification = "XMGRootViewControllerSwitchNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 设置网路指示器
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        // 设置网络缓存
        /*
        memoryCapacity: 内存大小
        diskCapacity: 磁盘大小
        diskPath: 磁盘路径
        */
        let urlCache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        NSURLCache.setSharedURLCache(urlCache)
        
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchRootViewController:", name: XMGRootViewControllerSwitchNotification, object: nil)
        
        // 0.设置外观
        setupAppearance()
        
        // 1.创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = defaultController()
        // 2.显示window
        window?.makeKeyAndVisible()
        
        return true
    }

    /**
     监听通知切换控制器
     */
    func switchRootViewController(notification : NSNotification)
    {
        let isMainVC = notification.object as! Bool
        window?.rootViewController = isMainVC ? MainViewController() : WelcomeViewController()
    }
    
    private func defaultController() -> UIViewController{
        if UserAccount.loadAccount() != nil{
            // 用户已经登录
            return isNewUpdate() ? NewfeatureViewController() : WelcomeViewController()
        }
        
        // 用户没有登录
        return MainViewController()
    }
    
    /// 检查是否有新版本
    private func isNewUpdate() -> Bool
    {
        // 1.获取应用程序当前版本
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        // 2.获取沙河应用程序版本
        let sandboxVersion = NSUserDefaults.standardUserDefaults().valueForKey("CFBundleShortVersionString") as? String ?? "0.0"
        
        // 3.利用当前版本和以前版本比较
        // 1.0                      0.9
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending{
            // 3.1如果有新版本, 将新版本保存到偏好设置中
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(currentVersion, forKey: "CFBundleShortVersionString")
            // iOS 7.0 之后，就不需要同步了，iOS 6.0 之前，如果不同步不会第一时间写入沙盒
            defaults.synchronize()
            // 4.返回时候有新版本
            return true
        }
        return false
    }

    /**
     设置外观
     */
    private func setupAppearance(){
        // 一经设置，全局有效，应该尽早设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
    }
}

