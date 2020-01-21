//
//  Router.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 31/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

//import UIKit
//import Alamofire
//
//
//
//enum Router: URLRequestConvertible {
//
//    //    static let baseAPIURLString = BASE_URL
//    
//    case equipmentList([String: Any])
//    
//
//    func asURLRequest() throws -> URLRequest {
//        var method: HTTPMethod {
//            switch self {
//           
//            case .equipmentList:
//                return .post
//            }
//        }
//
//        let params: ([String: Any]?) = {
//            switch self {
//            case .equipmentList(let params):
//                return (params)
//            }
//        }()
//
//        let url: URL = {
//            // build up and return the URL for each endpoint
//            
//            let urlString   =   "https://musicworldcupdevelopment.com/Apps/profile"
//            return URL(string: urlString)!
//        }()
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = method.rawValue
//      //  urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        let encoding = URLEncoding()//JSONEncoding.default
//        return try encoding.encode(urlRequest, with: params)
//    }
//}
//
