//
//  HttpUtils.swift
//  FunIOS
//
//  Created by redli on 2021/7/21.
//

import Foundation
import HandyJSON
import Alamofire

enum MethodType {
    case get
    case post
}

class HttpUtils {
    
    // static 也可以用 class 替代 效果是一样的
    static func request<T>(url: String, type: MethodType? = MethodType.get, params: [String: Any]? = nil, block: @escaping(_ result: T?) -> ()) {
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
//        let headers: HTTPHeaders = ["Cookie": ""]
        
        print("请求地址 ---> \(baseUrl + url)")
        
        AF.request(baseUrl + url, method: method, parameters: params).responseJSON { response in
            
            guard let data = response.value else {
                block(nil)
                log(log: "请求失败  ---> \(response.error?.errorDescription ?? "")")
                return
            }
            
            let result = JSONDeserializer<BaseResponse<T>>.deserializeFrom(dict: data as? [String: Any])
        
            if result?.errorCode == 0 {
                block(result?.data)
                print("请求成功 ---> \(baseUrl + url)")
                print(response.value ?? "")
            } else{
                block(nil)
            }
        }
    }
}
