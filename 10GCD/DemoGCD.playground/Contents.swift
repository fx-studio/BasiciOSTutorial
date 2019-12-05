import UIKit

//let queue = DispatchQueue(label: "com.fx.myqueue")
//
//queue.async {
//    for i in 0..<10 {
//        print("🔴", i)
//    }
//}
//
//for i in 100..<110 {
//    print("🔶", i)
//}

//let queue1 = DispatchQueue(label: "com.fx.myqueue1", qos: .userInitiated)
//let queue2 = DispatchQueue(label: "com.fx.myqueue2", qos: .utility)
//
//queue1.async {
//    for i in 0..<10 {
//        print("🔴", i)
//    }
//}
//
//queue2.async {
//    for i in 100..<110 {
//        print("🔵", i)
//    }
//}
//
//for i in 100..<110 {
//    print("🔶", i)
//}

////custom
//let customQueue = DispatchQueue(label: "com.fx.customqueue", qos: .utility)
//customQueue.async {
//    for i in 1000..<1010 {
//        print("🔶", i)
//    }
//}
//
////main
//DispatchQueue.main.async {
//    for i in 0..<10 {
//        print("🔴", i)
//    }
//}
//
////global
//DispatchQueue.global().async {
//    for i in 100..<110 {
//        print("🔵", i)
//    }
//}


/// Concurrent Queue
//let queue = DispatchQueue(label: "com.fx.myqueue", qos: .utility, attributes: [.initiallyInactive, .concurrent])
//
//queue.async {
//    for i in 0..<10 {
//        print("🔴", i)
//    }
//}
//
//queue.async {
//    for i in 100..<110 {
//        print("🔵", i)
//    }
//}
//
//queue.async {
//    for i in 1000..<1010 {
//        print("⚫️", i)
//    }
//}
//
//print("Do something 1")
//print("Do something 2")
//print("Do something 3")
//
//queue.activate()
//
//print("Do something 4")

///Delay

//

///Global Queue
//let globalQueue = DispatchQueue.global(qos: .userInitiated)
//globalQueue.async {
//    for i in 0..<10 {
//        print("🔴", i)
//    }
//}

///Main Queue
DispatchQueue.main.async {
    //code here
}

DispatchQueue.global().async {
    //do some task
    
    DispatchQueue.main.async {
        //update UI & Data here
    }

}

//func fetchImage(urlString: String) {
//    //1
//    let url = URL(string: urlString)
//
//    //2
//    (URLSession(configuration: .default).dataTask(with: url!, completionHandler: { (data, response, error) in
//
//        if let data = data {
//
//            //3
//            let image = UIImage(data: data)
//
//            //4
//            DispatchQueue.main.async {
//                self.imageView.image = image
//            }
//        }
//
//        })).resume()
//}

///DispatchWorkItem
var value = 10

let workItem = DispatchWorkItem {
    value += 5
}

print(value)

workItem.perform()
print(value)

let queue = DispatchQueue.global()
queue.async(execute: workItem)

workItem.notify(queue: DispatchQueue.main) {
    print(value)
}

class ViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .userInitiated).async {
        
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            self.taskOne {
                print("ONE -> DONE")
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            self.taskTwo {
                print("TWO -> DONE")
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            self.taskThree {
                print("THREE -> DONE")
                dispatchGroup.leave()
            }
            
            dispatchGroup.wait()
            
            dispatchGroup.notify(queue: .main) {
                print("ALL DONE")
            }
        }
        
    }
    
    func taskOne(completion: @escaping () -> Void) {
        print("task one")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion()
        }
    }
    
    func taskTwo(completion: @escaping () -> Void) {
        print("task two")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completion()
        }
    }

    func taskThree(completion: @escaping () -> Void) {
        print("task three")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion()
        }
    }

}
