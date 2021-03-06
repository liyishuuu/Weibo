//
//  WBNetWorkManager.swift
//  Weibo
//
//  Created by liyishu on 2019/6/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import AFNetworking  /// 导入框架文件夹的名字

/// enum swift 中支持任意数据类型
/// 网络请求方式
enum WBHttpMethod {
    case GET
    case POST
}

// 网络管理工具
class WBNetWorkManager: AFHTTPSessionManager {
    
    /** 静态区，常量，闭包 */
    static let shared = WBNetWorkManager()

    /** 用户账号的懒加载属性 */
    lazy var userAccount = WBUserAccountModel()

    /** 用户登录标记 */
    var userlogon: Bool {
        return userAccount.access_token != nil
    }

    /// 专门负责token的拼接 网络请求方法
    func tokenRequest(method: WBHttpMethod = .GET, URLSting: String, parameters: [String: AnyObject]?, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        
        // 处理token字典∫
        // 0.判断token是否为nil，如果是直接返回
        guard let token = userAccount.access_token else {
            print("没有token， 需要登录")

            // 发送通知，提醒用户登录
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUsershouldLoginNotification),
                                            object: nil)
            completion(nil, false)
            return
        }

        // 1.判断参数字典是否存在
        var parameters = parameters
        if parameters == nil {

            // 实例化字典
            parameters = [String: AnyObject]()
        }

        // 2. 设置参数字典，代码在此处字典一定有值
        parameters!["access_token"] = token as AnyObject
        
        // 调用request 发起真正的网络请求方法
        request(URLSting: URLSting, parameters: parameters!, completion: completion)
    }

    /// 封装 AFN 的GET/POST 请求
    ///
    /// - Parameters:
    ///   - method: GET/POST
    ///   - URLSting: URLSting
    ///   - parameters: 参数字典
    ///   - completion: 完成回调 json(数组/字典), 是否成功
    func request(method: WBHttpMethod = .GET, URLSting: String, parameters: [String: AnyObject]?, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        
        // 成功回调
        let success = { (task: URLSessionDataTask, json: Any?) ->() in
            completion(json as AnyObject?, true)
        }
        
        // 失败回调
        let failure =  {(task: URLSessionDataTask?, Error: Error) ->() in
            
            // 针对403 处理用户token过期
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("token过期")
                
                // TODO:发送通知，提醒用户再次登录
                NotificationCenter.default.post(name: Notification.Name.init(WBUsershouldLoginNotification),
                                                object: "bad token")
            }
            print("网络请求错误\(Error)")
            completion(nil, false)
        }
        if method == .GET {
            get(URLSting, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(URLSting, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
    
}
