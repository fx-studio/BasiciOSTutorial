//
//  User.swift
//  DetachedTaskDemo2
//
//  Created by Tien Le P. VN.Danang on 11/29/21.
//

import Foundation

actor User {
    func login() {
        Task {
            if authenticate(user: "taytay89", password: "n3wy0rk") {
                print("Successfully logged in.")
            } else {
                print("Sorry, something went wrong.")
            }
        }
    }
    
    func login2() {
            Task.detached {
                if await self.authenticate(user: "taytay89", password: "n3wy0rk") {
                    print("Successfully logged in.")
                } else {
                    print("Sorry, something went wrong.")
                }
            }
        }


    func authenticate(user: String, password: String) -> Bool {
        // Complicated logic here
        return true
    }
}
