//
//  ViewController.swift
//  DemoUserDefaults
//
//  Created by Tien Le P. VN.Danang on 2/8/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // #1:
        let userdefault = UserDefaults.standard
        //userdefault.set("Hello", forKey: "hello")
        print(userdefault.string(forKey: "hello") ?? "n/a")
        
        print(userdefault.integer(forKey: "total"))
        
        // Custom Type
        let user = User(name: "chuotfx", age: 22)
        // write
        let encoder = JSONEncoder()
        if let encodedUser = try? encoder.encode(user) {
            userdefault.set(encodedUser, forKey: "user")
        }
        // read
        if let savedUserData = userdefault.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let savedUser = try? decoder.decode(User.self, from: savedUserData) {
                print("Saved user: \(savedUser)")
            }
        }
        
        // register
        let userDefaults = UserDefaults.standard
        userDefaults.register(
            defaults: [
                "enabledSound": true,
                "enabledVibration": true
            ]
        )

        print(userDefaults.bool(forKey: "enabledSound")) // true
    }


}

struct User: Codable {
    let name: String
    let age: Int
}
