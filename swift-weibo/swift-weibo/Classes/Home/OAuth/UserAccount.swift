//
//  UserAccount.swift
//  XMGWB
//
//  Created by 李南江 on 15/9/9.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    // 用于调用access_token，接口获取授权后的access token
    var access_token: String?
    /// access_token的生命周期，单位是秒数
    var expires_in: NSNumber?
        {
        didSet{
            expires_Date = NSDate(timeIntervalSinceNow: (expires_in?.doubleValue)!)
            print("真正过期时间: \(expires_Date)")
        }
    }
    /// 真实过期时间
    var expires_Date: NSDate?
    /// 当前授权用户的UID
    var uid: String?
    /// 友好显示名称
    var name: String?
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    init(dict: [String: AnyObject])
    {
        /*
        access_token = dict["access_token"] as? String;
        expires_in = dict["expires_in"] as? NSNumber;
        uid = dict["uid"] as? String;
        */
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    // MARK: - 加载用户信息
    func loadUserInfo(finished: (account: UserAccount?, error: NSError?) ->())
    {
        // 1.请求地址
        let urlString = "2/users/show.json"
        // 2.请求参数
        let params = ["access_token": access_token!,"uid" : uid!]
        
        // 3.发送请求
        /// 加载用户信息 － 调用方法，异步获取用户附加信息，保存当前用户信息
        NetworkTools.sharedNetworkTools().GET(urlString, parameters: params, success: { (_, JSON) -> Void in
            
            // 1.获取用户信息
            let dict = JSON as! [String : AnyObject]
            self.name = dict["name"] as? String
            self.avatar_large = dict["avatar_large"] as? String
            
            // 2.保存用户信息
            self.saveAccount()
            
            // 3.返回调用信息
            finished(account: self, error: nil)
            
            }) { (_, error) -> Void in
                print(error)
                finished(account: nil, error: error)
        }
    }
    /// 用户是否登录标记
    class func userLogin() -> Bool {
        return loadAccount() != nil
    }
    
    // MARK: - 保存授权信息
    /// 沙河路径
    static let accountPath = "account.plist".cacheDir()
    
    /**
    将当前对象归档保存至沙盒
    */
    func saveAccount()
    {
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath)
    }
    
    /// 静态的用户账户属性
    static var account: UserAccount?
    /**
    加载授权信息
    
    :returns: 授权对象, 可能为nil
    */
    class func loadAccount() -> UserAccount?
    {
        // 1.判断是否过期
        if let date = account?.expires_Date where (date.compare(NSDate()) == NSComparisonResult.OrderedAscending)
        {
             // 如果已经过期，需要清空账号记录
            account = nil
        }
        // 2.判断是否已经加载过
        if account != nil
        {
            return account
        }
        // 3.从归档文件中加载
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.accountPath) as? UserAccount
        return account
    }
    
    // MARK: - NSCoding 归档接档使用的 key 保持一致即可
    ///  归档，aCoder 编码器，将对象转换成二进制数据保存到磁盘，和序列化很像
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
    }
    ///  解档方法，aDecoder 解码器，将保存在磁盘的二进制文件转换成 对象，和反序列化很像
    required init?(coder aDecoder: NSCoder)
    {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
    }
    
    /// 属性列表
    let properties = ["access_token", "expires_in", "uid", "name", "avatar_large"]
    /// 打印对象信息
    override var description: String {
        return "\(self.dictionaryWithValuesForKeys(properties))"
    }
}
