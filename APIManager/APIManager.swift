//
//  APIManager.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/19.
//

import UIKit

import Alamofire
import SwiftyJSON
import JGProgressHUD

class APIManager {
    static var shared = APIManager()
    private init() {}
    
    typealias complitionHandler = (Int, [String]) -> Void
    
    func requsetAPI(query: String, startPage: Int, complitionHandler: @escaping complitionHandler) {
        let url = APIURL.unsplashURL + "page=\(startPage)&query=\(query)&client_id=" + APIKEY.unsplash
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let totalCount = json["total_pages"].intValue
                let list = json["results"].arrayValue.map{ $0["urls"]["small"].stringValue}
                
                print(list, "ffffffffffff")
                
                complitionHandler(totalCount, list)
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
