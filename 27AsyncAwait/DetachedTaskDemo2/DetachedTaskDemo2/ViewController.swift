//
//  ViewController.swift
//  DetachedTaskDemo2
//
//  Created by Tien Le P. VN.Danang on 11/28/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Task {
//            let infor = await getInfo()
//            print("Infor: \(infor)")
//        }
//        
//        Task {
//            let user = User()
//            await user.login()
//        }
        
        doWork2()
    }
    
    func getInfo() async -> (String, Int) {
        let name = await getName()
        let friends = await getFriends()
        
        Task.detached(priority: .background) {
            await self.saveInfor(name: name, friends: friends)
        }
        
        let infor = (name, friends)
        print("return ...")
        return infor
    }
    
    func getName() async -> String {
        print("--> getName")
        return "Fx Studio"
    }
    
    func getFriends() async -> Int {
        print("--> getFriends")
        return 9999
    }
    
    func saveInfor(name: String, friends: Int) async {
        print("Saving: \(name) - \(friends) ...")
    }

    @IBAction func tapme(_ sender: Any) {
//        Task.detached {
//            await self.nameLabel.text = "AAAA"
//        }
    }
    
    func doWork() {
        Task {
            for i in 1...10 {
                print("🔵 #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
                print("In Task 1: \(i)")
            }
        }

        Task {
            for i in 1...10 {
                print("🔴 #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
                print("In Task 2: \(i)")
            }
        }
    }
    
    func doWork2() {
        Task.detached {
            for i in 1...10 {
                print("🔵 #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
                print("In Task 1: \(i)")
            }
        }

        Task.detached {
            for i in 1...10 {
                print("🔴 #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
                print("In Task 2: \(i)")
            }
        }
    }

}

extension OperationQueue {
    static func mainQueueChecker() -> String {
        return Self.current == Self.main ? "✅" : "❌"
    }
}
