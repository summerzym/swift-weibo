
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

        if !userLogin{
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
        }
    }

}
