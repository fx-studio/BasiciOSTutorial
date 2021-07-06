//
//  HomeViewController.swift
//  DemoAPI
//
//  Created by Tien Le P. VN.Danang on 7/3/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var imageView: UIImageView!
    
    let serialQueue = DispatchQueue(label: "serialQueue")
    var subscriptions = Set<AnyCancellable>()
    var viewmodel = HomeViewModel()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel.$image
            .assign(to: \.image, on: imageView)
            .store(in: &subscriptions)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Data Race on Thread UI
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
        // Completion Handle
//        viewmodel.loadImage { image in
//            self.imageView.image = image
//        }
        
        // Publisher
//        viewmodel.loadImage2()
        
        // Async/Await
//        async {
//            await viewmodel.loadImage3()
//        }
        
        // Completion + MainActor
        viewmodel.loadImage4 { image in
            self.imageView.image = image
        }
    }
    
    // MARK: Function
    @MainActor
    func changeImageBackground(_ color: UIColor, title: String)  {
        print("\(title) - MainThread is \(OperationQueue.mainQueueChecker())")
        self.imageView.backgroundColor = color
    }

}
