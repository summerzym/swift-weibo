//
//  NewfeatureViewController.swift
//  XMGWB
//
//  Created by 李南江 on 15/9/9.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
class NewfeatureViewController: UICollectionViewController {
    
    /// 图像总数
    private let imageCount = 4
    /// 布局属性
    private let layout = XMGFlowLayout()
    
    // 没有 override，因为 collectionView 的指定的构造函数是带 layout 的
    init(){
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView?.registerClass(NewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: UICollectionViewDataSource
    // 1. 获取数据源，确认有 cell
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCount
    }
    // 3. 获取每个索引对应的cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewfeatureCell
        cell.imageIndex = indexPath.item
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // 传递过来的是上一页的item
//        print(indexPath.item)
         // 获取当前显示的 indexPath
        let path = collectionView.indexPathsForVisibleItems().last!
//        print(path.item)
        // 判断是否是末尾的 indexPath
        if path.item == (imageCount - 1)
        {
             // 播放动画
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewfeatureCell
            cell.startBtnAmiatino()
        }
    }
}

private class NewfeatureCell: UICollectionViewCell {
    
    /// 图像索引 - 私有属性，在同一个文件中，是允许访问的！
    private var imageIndex: Int = 0 {
        didSet {
            iconView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            startButton.hidden = true
            /*
            // 动画会有问题
            if imageIndex == 3
            {
                startButton.hidden = false
                startBtnAmiatino()
            }
            */
        }
    }
    /**
    开始按钮动画
    */
    func startBtnAmiatino(){
        startButton.hidden = false
        // 设置形变
        startButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
        // 禁用按钮操作
        startButton.userInteractionEnabled = false
        
        // 同学们看这里: http://www.tuicool.com/articles/ZR7nYv
        UIView.animateWithDuration(1.2, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                // 恢复默认形变
                self.startButton.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                // 启用按钮点击
                self.startButton.userInteractionEnabled = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 初始化UI
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI()
    {
        // 1.添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        // 2.布局子控件
        iconView.xmg_Fill(contentView)
        startButton.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
    }
    
    // MARK: - 懒加载控件
    private lazy var iconView = UIImageView()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        button.setTitle("开始体验", forState: UIControlState.Normal)
        
        // 根据背景图片自动调整大小
        button.sizeToFit()
        
        button.addTarget(self, action: "clickStartButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
        }()
    /**
    开始体验按钮监听
    */
    private func clickStartButton(){
        print(__FUNCTION__)
        // 发送通知, 切换道主界面
        NSNotificationCenter.defaultCenter().postNotificationName(XMGRootViewControllerSwitchNotification, object: true)
    }
}

/// 自定义流水布局
private class XMGFlowLayout: UICollectionViewFlowLayout {
     // 2. 如果还没有设置 layout，获取数量之后，准备cell之前，会被调用一次
    // 准备布局属性
    override func prepareLayout()
    {
        itemSize = (collectionView?.bounds.size)!
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
