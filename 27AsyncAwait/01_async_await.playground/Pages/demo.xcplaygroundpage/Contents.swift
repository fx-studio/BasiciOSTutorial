//: [Previous](@previous)

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

func hamA() async -> String {
    await withCheckedContinuation({ c in
        Thread.sleep(forTimeInterval: 2.0)
        c.resume(returning: "AAAA")
    })
}

func hamB() async -> String {
    "BBBB"
}

async {
    print("#1")
    let a = await hamA()
    print("#2")
    let b = await hamB()
    print("\(a) & \(b)")
}
//
//async {
//    print("#2")
//    await hamB()
//}


//: [Next](@next)
