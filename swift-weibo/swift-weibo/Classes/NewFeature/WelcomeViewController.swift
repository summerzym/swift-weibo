//
//  WelcomeViewController.swift
//  XMGWB
//
//  Created by 李南江 on 15/9/9.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    /// 图像底部约束
    private var iconBottomCons: NSLayoutConstraint?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.初始化UI
        setupUI()
        
        // 2.设置用户信息
        if let iconUrlStr = UserAccount.loadAccount()?.avatar_large{
            // 更新图像，会自动更新imageView的大小
            iconView.sd_setImageWithURL(NSURL(string: iconUrlStr))
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 提示：修改约束不会立即生效，添加了一个标记，统一由自动布局系统更新约束
        iconBottomCons?.constant = -UIScreen.mainScreen().bounds.height - iconBottomCons!.constant
        print( -UIScreen.mainScreen().bounds.height)
        print(iconBottomCons!.constant)
        
        UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            // 强制更新约束
            self.view.layoutIfNeeded()
            }) { (_) -> Void in
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    self.message.alpha = 1.0
                    }, completion: { (_) -> Void in
                        print("OK")
                })
        }
    }
    
    /**
    初始化UI
    */
    private func setupUI()
    {
        // 1.添加子控件
        view.addSubview(bgImageView)
        view.addSubview(iconView)
        view.addSubview(message)
        
        // 2.布局子控件
        // 2.1约束背景
        bgImageView.xmg_Fill(view)
        
        // 2.2约束头像
        let cons = iconView.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: view, size: CGSize(width: 100, height: 100), offset: CGPoint(x: 0, y: -200))
        // 记录底部约束
        iconBottomCons = iconView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        // 2.3约束文字
        message.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 20))
    }
    
    // MARK: - 懒加载
    /// 背景图片
    private lazy var bgImageView: UIImageView = UIImageView(image:UIImage(named:"ad_background"))
    ///  头像
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.cornerRadius = 50
        iv.layer.masksToBounds = true
        return iv
        }()
    /// 消息文字
    private lazy var message: UILabel = {
        let label = UILabel()
        label.text = "欢迎归来"
        label.alpha = 0.0
        label.sizeToFit()
        return label
        }()
}
