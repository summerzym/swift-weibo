//
//  OAuthViewController.swift
//  swift-weibo
//
//  Created by SummerZhao on 16/5/17.
//  Copyright © 2016年 yunmei. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    // 0. 定义常量
    private let WB_Client_ID = "571108898"
    private let WB_REDIRECT_URI = "http://www.520it.com"
    private let WB_App_Secret = "b8bc70bf1bccafc167e52d5d094c9439"
    
    override func loadView() {
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.添加关闭按钮
        navigationItem.title = "swift微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        
        // 2.加载授权界面
        loadOAuthPage()
    }
    
    /**
     关闭当前视图
     */
    func close(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     加载授权界面
     */
    private func loadOAuthPage(){
        // 1.拼接字符串
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_Client_ID)&redirect_uri=\(WB_REDIRECT_URI)"
        // 2.创建URL
        let url = NSURL(string: urlString)!
        // 3.创建Request
        let request = NSURLRequest(URL: url)
        // 4.加载界面
        webView.loadRequest(request)
    }
    
    // MARK: - 懒加载
    // 利用webView加载授权页面
    private lazy var webView: UIWebView = {
        let wv = UIWebView()
        wv.delegate = self
        return wv
    }()
}

extension OAuthViewController: UIWebViewDelegate
{
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        // 0. 获取URL的完整字符串
        let urlStr = request.URL?.absoluteString
        // 1.如果不是回调的 URL，就继续加载
        if !urlStr!.hasPrefix(WB_REDIRECT_URI)
        {
            return true
        }
        // 2.如果是回调地址，需要根据 URL 中的内容，判断是否有授权码
        let query = request.URL?.query
        print(query)
        let codeStr = "code="
        if query!.hasPrefix(codeStr)
        {
            print("有授权Token")
            // 2.1取出code
            let code = query!.substringFromIndex(codeStr.endIndex)
            //            print("code: \(code)")
            loadAccessToken(code)
        }else
        {
            print("没有未授权Token")
            close()
        }
        return false
    }
    
    ///  使用授权码加载 token
    private func loadAccessToken(code: String) {
        // 1. urlString SSL 1.2
        let urlString = "oauth2/access_token"
        
        // 2. 请求参数
        let params = ["client_id": WB_Client_ID,
            "client_secret": WB_App_Secret,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": WB_REDIRECT_URI]
        
        // 3. 发起网络请求
        NetworkTools.sharedNetworkTools().POST(urlString, parameters: params, success: { (_, JSON) -> Void in
            //            print(JSON)
            // 1.字典转模型
            let account = UserAccount(dict: JSON as! [String : AnyObject])
            //            print(account)
            //            account.saveAccount()
            // 2.加载用户信息
            account.loadUserInfo({ (account, error) -> () in
                
                // 判断是否获取成功
                if account != nil{
                    // 发送通知, 切换道主界面
                    NSNotificationCenter.defaultCenter().postNotificationName(XMGRootViewControllerSwitchNotification, object: false)
                    // 因为是通过modal出来的, 所以一定要手动关闭
                    self.close()
                    print(account)
                    return
                }
                
                // 提示用户
                SVProgressHUD.showInfoWithStatus("网络不给力....", maskType: SVProgressHUDMaskType.Black)
            })
            
            }) { (_, error) -> Void in
                print(error)
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView)
    {
        SVProgressHUD.showInfoWithStatus("正在加载网页...", maskType: SVProgressHUDMaskType.Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        SVProgressHUD.dismiss()
    }
}
