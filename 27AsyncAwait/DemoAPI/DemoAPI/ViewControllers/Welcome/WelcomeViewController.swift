//
//  WelcomViewController.swift
//  DemoAPI
//
//  Created by Tien Le P. VN.Danang on 7/2/21.
//

import UIKit
import Combine

//@MainActor
class WelcomeViewController: UIViewController {
    //MARK: - Properties
     @IBOutlet weak var imageView: UIImageView!
    
    let actorWelcome = ActorWelcome()
    let viewModel = WelcomeViewModel()
    let viewModel2 = WelcomeViewModel2()
    var subscriptions = Set<AnyCancellable>()
    
    //MARK: - Life cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        detach(priority: .userInteractive) {
//            // Not Main Queue
//            print("#1 - \(OperationQueue.mainQueueChecker())")
//
//            // Main Queue
//            await self.changeBackgroundColor(.orange)
//        }
//
//        detach(priority: .background) {
//            // Not Main Queue
//            print("#2 - \(OperationQueue.mainQueueChecker())")
//
//            // Main Queue
//            await ActorObject.changeBackgroundColor(self, color: .blue)
//        }
        
        // MARK: #5 Thử @MainActor ở ngoài thread khác thì sao
        // ko có async mà có @MainActor
//        DispatchQueue.global().async {
//            //detach {
//                print("🔵 #\(0) - MainThread is \(OperationQueue.mainQueueChecker())")
//                 self.changeImageBackground(.blue, title: "🔵")
//            //}
//        }
        
        
        // MARK: #4 Không @MainActor & async + Actor
        // Cũng không giải quyết được vấn đề xung đột trên Main
        // Có @MainActor vào là xong
//        detach(priority: .userInteractive) { [self] in
//            print("🔵 #\(0) - MainThread is \(OperationQueue.mainQueueChecker())")
//            await changeImageBackground(.blue, title: "🔵")
//        }
//
//        //async {
//        detach(priority: .userInteractive) { [self] in
//            print("🔴 #\(0) - MainThread is \(OperationQueue.mainQueueChecker())")
//            await ActorWelcome.changeImageBackground(self, color: .red, title: "🔴")
//        }
        
        
        // MARK: #3
        // Cách chạy bất đồng bộ với async khác Main Thread
        // async
        //  - Function phải có async để chạy đồng thời trong này --> mọi thứ rất đẹp --> tất cả là Main
        // detach --> lỗi cập nhật UI khác Main
        //  - bỏ async đi thì function chạy ở Main --> await trong detach sẽ chờ đợi cập nhật
        //  - thêm async lại
        // Thêm @MainActor là triệu hồi function ở thread khác --> sẽ chạy ở Main & có async hay ko cũng ko quan trọng
        
//        //async {
//        detach(priority: .userInteractive) { [self] in
//            for i in 0..<10 {
//                print("🔵 #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
//                await changeImageBackground(.blue, title: "🔵")
//            }
//        }
//
//        //async {
//        detach(priority: .userInteractive) { [self] in
//            for i in 0..<10 {
//                print("🔴 #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
//                await changeImageBackground(.red, title: "🔴")
//            }
//        }
        
        // MARK: #2
        // Data Race
        // Xem kết quả log cuối cùng để check lại với UI
//        DispatchQueue.concurrentPerform(iterations: 10) { i in
//            if i % 2 == 0 {
//                print("🔵 #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
//                changeImageBackground2(.blue, title: "🔵")
//            } else {
//                print("🔴 #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
//                changeImageBackground2(.red, title: "🔴")
//            }
//        }
        
        // MARK: #1
        // cập nhật UI tại thread khác
        // 1. 1 task chạy
        // 2. nhiều task chạy
        // ==> Data Race
//        DispatchQueue.global(qos: .userInteractive).async {
//            for i in 0..<10 {
//                print("🔵 #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
//                self.changeImageBackground2(.blue, title: "🔵")
//            }
//        }
//
//        DispatchQueue.global(qos: .userInteractive).async {
//            for i in 0..<10 {
//                print("🔴 #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
//                self.changeImageBackground2(.red, title: "🔴")
//            }
//        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.$image
            .assign(to: \.image, on: imageView)
            .store(in: &subscriptions)
        
        viewModel2.$image
            .assign(to: \.image, on: imageView)
            .store(in: &subscriptions)
    }
    
    //MARK: - Load Data

    //MARK: - Actions
    @IBAction func start(_ sender: Any) {
        // cách 1
//        async {
//            await viewModel.loadImage()
//        }
        
        // cách 2
//        viewModel.loadImage2()
        
        // cách 3
//        viewModel.loadImage3 { image in
//            self.imageView.image = image
//        }
        
        // cách 4: Combine
        viewModel2.loadImage()
    }

    func changeBackgroundColor(_ color: UIColor) async {
        // Main Queue
        print("#3 - \(OperationQueue.mainQueueChecker())")
        view.backgroundColor = color
    }
    
    
    // Có nó thì bạn không cần tới DispatchQueue.main
    // Luôn luôn được cập nhật ở Main cho đồng bộ
    
    @MainActor
    func changeImageBackground(_ color: UIColor, title: String) {
        // Main Queue
        print("\(title) - MainThread is \(OperationQueue.mainQueueChecker())")
        imageView.backgroundColor = color
    }
    
    func changeImageBackground2(_ color: UIColor, title: String) {
        DispatchQueue.main.async {
            // Main Queue
            print("\(title) - MainThread is \(OperationQueue.mainQueueChecker())")
            self.imageView.backgroundColor = color
        }
    }
    
}


extension OperationQueue {
    static func mainQueueChecker() -> String {
        return Self.current == Self.main ? "✅" : "❌"
    }
}

actor ActorWelcome {
    func changeImageBackground (_ vc: WelcomeViewController, color: UIColor, title: String) async {
        print("\(title + title) - \(OperationQueue.mainQueueChecker())")
        await vc.changeImageBackground2(.blue, title: title)
    }
    
    static func changeImageBackground (_ vc: WelcomeViewController, color: UIColor, title: String) async {
        print("\(title + title) - \(OperationQueue.mainQueueChecker())")
        await vc.changeImageBackground2(.blue, title: title)
    }
}

actor ActorObject: NSObject {
    static func changeBackgroundColor(_ vc: WelcomeViewController, color: UIColor) async {
        // Not Main Queue
        print("#5 - \(OperationQueue.mainQueueChecker())")
        
        // Main Queue
        await vc.changeBackgroundColor(.blue)
    }
    
    static func changeImageBackground(_ vc: WelcomeViewController, color: UIColor, title: String) async {
        // Not Main Queue
        print("#6 - \(OperationQueue.mainQueueChecker())")
        
        // Main Queue
        await vc.changeImageBackground(.blue, title: title + title)
    }
}
