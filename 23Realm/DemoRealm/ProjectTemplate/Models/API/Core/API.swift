//
//  API.swift
//  DemoNetworking
//
//  Created by Le Phuong Tien on 12/17/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import Foundation

//MARK: - Defines
enum APIError: Error {
    case error(String)
    case errorURL
    
    var localizedDescription: String {
        switch self {
        case .error(let string):
            return string
        case .errorURL:
            return "URL String is error."
        }
    }
}
    
typealias APICompletion<T> = (Result<T, APIError>) -> Void
    
enum APIResult {
    case success(Data?)
    case failure(APIError)
}

//MARK: - API
struct API {
    //singleton
    private static var shareAPI: API = {
        let shareAPI = API()
        return shareAPI
    }()
    
    static func shared() -> API {
        return shareAPI
    }
    
    //init
    private init() {}
}
