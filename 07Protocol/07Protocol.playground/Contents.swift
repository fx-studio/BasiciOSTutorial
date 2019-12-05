import UIKit
import Foundation

//MARK: Khai báo
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}

protocol AnotherProtocol {
    static var someTypeProperty: Int { get set }
}

////Implement in Struct
//struct SomeStructure: FirstProtocol, AnotherProtocol {
//    // structure definition goes here
//}
//
////Implement in Class
//class SomeClass: SomeSuperclass, FirstProtocol, AnotherProtocol {
//    // class definition goes here
//}

@objc protocol P {
    func show()
    func add(a: Int, b: Int) -> Int
    @objc optional func sum(array: [Int]) -> Int
}

class A: P {
    func show() {
        // code here
    }
    
    func add(a: Int, b: Int) -> Int {
        // code here
        return 0
    }
}

class B: P {
    func show() {
        // code here
    }
    
    func add(a: Int, b: Int) -> Int {
        // code here
        return 0
    }
    
    func sum(array: [Int]) -> Int {
        return 0
    }
}


//MARK: Thuộc tính
protocol FullyNamed {
    var fullName: String { get }
}

struct Person: FullyNamed {
    var fullName: String
}
let john = Person(fullName: "John Appleseed")

class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
}
var ncc1701 = Starship(name: "Enterprise", prefix: "USS")

//MARK: Phương thức
protocol RandomNumberGenerator {
    func random() -> Double
}

//MARK: Mutating
protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}
var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()
// lightSwitch is now equal to .on

//MARK: Init Method
protocol SomeProtocol2 {
    init()
}

class SomeSuperClass {
    init() {
        // initializer implementation goes here
    }
}

class SomeSubClass: SomeSuperClass, SomeProtocol2 {
    // "required" from SomeProtocol conformance; "override" from SomeSuperClass
    required override init() {
        // initializer implementation goes here
    }
}

//MARK: Class-only
protocol ForClassProtocol: class {
    func test()
}
 
class TestClass: ForClassProtocol {
    func test() {}
}

class TestAnotherClass {
    weak var delegate: ForClassProtocol?
}

//
//struct TestStruct: ForClassProtocol {
//    func test() {}
//}
//
//enum TestEnum:ForClassProtocol {
//    func test() {}
//}


//MARK: Extension
class C {
    var a: Int
    var b: Int
    var result: Int = 0
    
    init(a: Int, b: Int) {
        self.a = a
        self.b = b
    }
}


extension C: P {
    func show() {
        print("result: \(result)")
    }
    
    func add(a: Int, b: Int) -> Int {
        return a + b
    }
}

 
