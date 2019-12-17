//
//  RegisterViewModel.swift
//  DemoMVVM
//
//  Created by Tien Le P. on 7/12/18.
//  Copyright © 2018 Tien Le P. All rights reserved.
//

import Foundation


final class RegisterViewModel {

    // MARK: - Properties
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var brithday: String = ""
    
    // MARK: - enum
    enum RegisterResult {
        case success
        case failure(Error)
    }
    
    // MARK: - typealias
    typealias Completion = (RegisterResult) -> Void

    // MARK: - Register
    func register(completion: @escaping Completion) -> Void {
        print("Connect API Register ... ")
        
        name = "No name"
        email = "No email"
        password = "No password"
        brithday = "1/1/2018"
        
        let ok = arc4random_uniform(2) == 0 ? true : false
        print("Giả lập gọi API")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("API trả dữ liệu về")
            if ok {
                //parse data --> save DB
                completion(.success)
            } else {
                let info: [String: Any] = [
                    NSLocalizedDescriptionKey: "Server not found"
                ]
                let error = NSError(domain: "", code: -1, userInfo: info)
                completion(.failure(error))
            }
        }
        print("bbbbb")
    }
    
    // MARK: - private function
    func validate() -> Bool {
        return true
    }
    
    
}
