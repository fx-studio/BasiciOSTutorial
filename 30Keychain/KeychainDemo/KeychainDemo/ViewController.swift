//
//  ViewController.swift
//  KeychainDemo
//
//  Created by Tien Le P. VN.Danang on 1/24/22.
//

import UIKit
import Security

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteItems()
        retrievingItems()
    }
    
    func addItem() {
        let query = [
            kSecValueData: "FxStudio".data(using: .utf8)!,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        let status = SecItemAdd(query, nil)
        print("Status: \(status)")
    }
    
    func addItemAndStatus() {
        let query = [
            kSecValueData: "hello_keychain".data(using: .utf8)!,
            kSecAttrAccount: "chuotfx",
            kSecAttrServer: "fxstudio.dev",
            kSecClass: kSecClassInternetPassword
        ] as CFDictionary

        let status = SecItemAdd(query, nil)
        print("Status: \(status)")
    }
    
    func addItemAndReturnAtributes() {
        let query = [
            kSecValueData: "hello_keychain".data(using: .utf8)!,
            kSecAttrAccount: "chuotfx1",
            kSecAttrServer: "fxstudio.dev",
            kSecClass: kSecClassInternetPassword,
            kSecReturnAttributes: true
        ] as CFDictionary

        var ref: AnyObject?

        let status = SecItemAdd(query, &ref)
        print("Status: \(status)")
        print("Result:")
        let result = ref as! NSDictionary
        result.forEach { key, value in
            print("\(key) : \(value)")
        }
    }
    
    func addItemAndReturnData() {
        let query = [
          kSecValueData: "abcd1234".data(using: .utf8)!,
          kSecAttrAccount: "admin",
          kSecAttrServer: "fxstudio.dev",
          kSecClass: kSecClassInternetPassword,
          kSecReturnData: true,
          kSecReturnAttributes: true
        ] as CFDictionary

        var ref: AnyObject?

        let status = SecItemAdd(query, &ref)
        let result = ref as! NSDictionary
        print("Operation finished with status: \(status)")
        print("Username: \(result[kSecAttrAccount] ?? "")")
        let passwordData = result[kSecValueData] as! Data
        let passwordString = String(data: passwordData, encoding: .utf8)
        print("Password: \(passwordString ?? "")")

    }
    
    func retrievingItems() {
        let query = [
          kSecClass: kSecClassInternetPassword,
          kSecAttrServer: "fxstudio.dev",
          kSecReturnAttributes: true,
          kSecReturnData: true,
          kSecMatchLimit: 20
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        print("Operation finished with status: \(status)")
        let array = result as! [NSDictionary]

        array.forEach { dic in
          let username = dic[kSecAttrAccount] ?? ""
          let passwordData = dic[kSecValueData] as! Data
          let password = String(data: passwordData, encoding: .utf8)!
          print("Username: \(username)")
          print("Password: \(password)")
        }
    }
    
    func retrievingItem() {
        let query = [
          kSecClass: kSecClassInternetPassword,
          kSecAttrServer: "fxstudio.dev",
          kSecReturnAttributes: true,
          kSecReturnData: true,
          //kSecMatchLimit: 20
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        print("Operation finished with status: \(status)")
        let dic = result as! NSDictionary

        let username = dic[kSecAttrAccount] ?? ""
        let passwordData = dic[kSecValueData] as! Data
        let password = String(data: passwordData, encoding: .utf8)!
        print("Username: \(username)")
        print("Password: \(password)")
    }

    func updateItems() {
        let query = [
          kSecClass: kSecClassInternetPassword,
          kSecAttrServer: "fxstudio.dev",
        ] as CFDictionary

        let updateFields = [
          kSecValueData: "ahihi".data(using: .utf8)!
        ] as CFDictionary

        let status = SecItemUpdate(query, updateFields)
        print("Operation finished with status: \(status)")
    }
    
    func updateItem() {
        let query = [
          kSecClass: kSecClassInternetPassword,
          kSecAttrServer: "fxstudio.dev",
          kSecAttrAccount: "admin"
        ] as CFDictionary

        let updateFields = [
          kSecValueData: "admin".data(using: .utf8)!
        ] as CFDictionary

        let status = SecItemUpdate(query, updateFields)
        print("Operation finished with status: \(status)")
    }
    
    func deleteItems() {
        let query = [
          kSecClass: kSecClassInternetPassword,
          kSecAttrServer: "fxstudio.dev",
          kSecAttrAccount: "admin"
        ] as CFDictionary

        SecItemDelete(query)

    }

}

