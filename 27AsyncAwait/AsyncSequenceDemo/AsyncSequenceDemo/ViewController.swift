//
//  ViewController.swift
//  AsyncSequenceDemo
//
//  Created by Tien Le P. VN.Danang on 12/1/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            await readData()
        }
        
        Task {
            for try await item in Typing(phrase: "Hello, Fx Studio!") {
              print(item)
            }
        }
    }
    
    func readData() async {
        if let url = Bundle.main.url(forResource: "data", withExtension: "txt") {
            do {
                
                let items = url.lines
                    .map { Int($0) ?? 0 }
                    .filter { $0 % 2 != 0 }
                    .map { MyItem(number: $0) }
                
                for try await item in items {
                    print(item.number)
                }
                
            } catch {
                print(error)
            }
        }
    }
}

struct MyItem {
    var number: Int
}

