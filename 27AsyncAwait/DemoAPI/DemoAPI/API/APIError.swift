//
//  APIError.swift
//  DemoAPI
//
//  Created by Tien Le P. VN.Danang on 6/25/21.
//

import Foundation

enum APIError: Error {
    case error(String)
    
    var localizedDescription: String {
        switch self {
        case .error(let string):
            return string
            
        }
    }
}
