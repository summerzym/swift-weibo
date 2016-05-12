//
//  VisitorView.swift
//  swift-weibo
//
//  Created by SummerZhao on 16/5/11.
//  Copyright © 2016年 yunmei. All rights reserved.
//
import UIKit

protocol VistorViewDelegate:NSObjectProtocol{
    //登录回调
    func loginBtnWillClick()
    
    //注册回调
    func registerBtnWillClick()
}

class VisitorView: UIView {
    
    //代理必须设置为weak
    weak var delegate:VistorViewDelegate?
    
    func setupVisitorInfo(isHome :Bool, imageName:String, message: String){
        iconView.hidden = !isHome
        homeIconView.image = UIImage(named: imageName)
        messageLabel.text = message
        
        if isHome{
            startAnination()
        }
    }
    
    func loginBtnClick(){
        delegate?.loginBtnWillClick()
    }
    
    func registerBtnClick(){
        delegate?.registerBtnWillClick()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }
    
    // 必须重写这个方法, Swift推荐我们要么支持纯代码, 要么支持XIB
    // 这样可以简化代码的复杂度
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        // 1. 添加控件
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(homeIconView)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        // 2. 自动布局
        /*
        注意:
        纯代码开发时默认可以直接使用setFrame设置控件位置的
        如果要使用自动布局，需要设置translatesAutoresizingMaskIntoConstraints属性
        一旦加入自动布局系统管理，就不要再设置frame
        */
        // 2.1背景图标
        iconView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        // 2.2遮罩
        maskIconView.xmg_Fill(self)
        // 2.3小房子
        homeIconView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        // 2.4消息文字
        messageLabel.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: iconView, size: nil)
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224))
        // 2.5注册按钮
        registerButton.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: messageLabel, size: CGSize(width: 100, height: 35), offset: CGPoint(x: 0, y: 20))
        // 2.6登录按钮
        loginButton.xmg_AlignVertical(type: XMG_AlignType.BottomRight, referView: messageLabel, size: CGSize(width: 100, height: 35), offset: CGPoint(x: 0, y: 20))
    }
    
    // MARK: - 内部控制方法
    private func startAnination(){
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        anim.toValue = 2*M_PI
        
        anim.removedOnCompletion = false
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    
    // MARK: - 懒加载
    /// 背景图标
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return iv
    }()
    
    /// 遮罩视图
    // 注意系统有一个叫做maskView的属性, 属性名称不能叫做maskView
    private lazy var maskIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        
        return iv
    }()
    
    /// 小房子
    private lazy var homeIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return iv
    }()
    
    /// 消息文字
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "关注一些人，回这里看看有什么惊喜"
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    /// 注册按钮
    private lazy var registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: "registerBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    /// 登录按钮
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: "loginBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
}

