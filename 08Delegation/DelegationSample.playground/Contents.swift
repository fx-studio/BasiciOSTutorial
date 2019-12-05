import UIKit

//MARK: Define delegate
protocol SubViewADelegate {
    func passData(data: String)
}

//MARK: Class View A
class ViewA {
    init() { }
}
//SubviewA Delegate
extension ViewA: SubViewADelegate {
    func passData(data: String) {
        print("Data: \(data)")
    }
}

//MARK: Class Sub-View A
class SubViewA {
    var delegate: SubViewADelegate?
    
    init() { }
    
    // action
    func doSomething(data: String) {
        if let delegate = delegate {
            delegate.passData(data: data)
        }
    }
}


//MARK: Do something
var viewA = ViewA()

var subViewA = SubViewA()
subViewA.delegate = viewA

//do something
subViewA.doSomething(data: "OK, let's me go")

