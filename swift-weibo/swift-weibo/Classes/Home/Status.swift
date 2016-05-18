//
//  Status.swift
//  XMGWB
//
//  Created by 李南江 on 15/9/10.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit

private let WB_HOME_TIMELINE = "2/statuses/home_timeline.json"
class Status: NSObject {
    /// 微博创建时间
    var created_at: String?
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?
    /// 配图数组
    var pic_urls: [[String: AnyObject]]?
    
    class func loadStatuses(finished: (statuses: [Status]?, error: NSError?)->()){
        let params = ["access_token": UserAccount.loadAccount()!.access_token!]
        
        NetworkTools.sharedNetworkTools().GET(WB_HOME_TIMELINE, parameters: params, success: { (_, JSON) -> Void in
            // 字典转换模型
            if let statuses = JSON!["statuses"] as? [[String: AnyObject]] {
                //                print(Status.status(statuses))
                let models = Status.status(statuses)
                finished(statuses: models, error: nil)
            }
            
            }) { (_, error) -> Void in
                print(error)
                finished(statuses: nil, error: error)
        }
    }
    /// 使用传入数组完成字典转模型
    private class func status(array: [[String:AnyObject]]) -> [Status]{
        var models = [Status]()
        for dict in array{
            models.append(Status(dict: dict))
        }
        return models
    }
    
    // 自定义构造函数
    init(dict: [String: AnyObject]){
        super.init()
        // 会调用 setValue forKey 给每一个属性赋值
        setValuesForKeysWithDictionary(dict)
    }
    // 如果没有对应的key会调用这个方法
    override func setValue(value: AnyObject?, forUndefinedKey key: String){
        print("找不到\(key)")
    }
    // 定义类属性数组
    static let properties = ["created_at", "id", "text", "source", "pic_urls"]
    // 打印对象
    override var description: String{
        return "\(self.dictionaryWithValuesForKeys(Status.properties))"
    }
}
