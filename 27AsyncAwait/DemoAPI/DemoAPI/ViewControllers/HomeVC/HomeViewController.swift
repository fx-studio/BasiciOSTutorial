//
//  HomeViewController.swift
//  DemoAPI
//
//  Created by Tien Le P. VN.Danang on 7/3/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var imageView: UIImageView!
    
    let serialQueue = DispatchQueue(label: "serialQueue")

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.concurrentPerform(iterations: 100) { i in
            detach {
                if i % 2 == 0 {
                    print("🔵 #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
                    await self.changeImageBackground(.blue, title: "🔵")
                } else {
                    print("🔴 #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
                    await self.changeImageBackground(.red, title: "🔴")
                }
            }
        }
    }

    // MARK: Actions
    @IBAction func start(_ sender: Any) {
    }
    
    // MARK: Function
    @MainActor
    func changeImageBackground(_ color: UIColor, title: String)  {
        print("\(title) - MainThread is \(OperationQueue.mainQueueChecker())")
        self.imageView.backgroundColor = color
    }

}
