//
//  UIBarButtonItem+Category.swift
//  swift-weibo
//
//  Created by SummerZhao on 16/5/12.
//  Copyright © 2016年 yunmei. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    class func createBarButtonItem(imageName:String, target:AnyObject?, action:Selector) -> UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action:action, forControlEvents: UIControlEvents.TouchUpInside)
        return UIBarButtonItem(customView: btn)
    }
}
