//
//  NullViewController.swift
//  swift-weibo
//
//  Created by SummerZhao on 16/5/11.
//  Copyright © 2016年 yunmei. All rights reserved.
//

import UIKit

class NullViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(VisitorView())
    }

    
    
}
