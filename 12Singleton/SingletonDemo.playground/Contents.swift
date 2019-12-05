import Foundation


class MyClass {
    init() {}
}

let shareMyClass = MyClass()


class User {
    //singleton
    private static var defaultUser = User(name: "default user")
    
    static func shared() -> User {
        return defaultUser
    }
    
    //properties
    var name: String
    
    //init
    init(name: String) {
        self.name = name
    }
    
    //method
    func say() {
        print(name)
    }
}

User.shared().say()

class DataManager {
    
    //singleton
    private static var sharedDataManager: DataManager = {
        let dataManager = DataManager()
        
        //config
        dataManager.configDatabase(databaseName: "BD")
        
        return dataManager
    }()
    
    class func shared() -> DataManager {
        return sharedDataManager
    }
    
    //properties
    var databaseName: String = ""
    
    // init
    private init() {}
    
    // config database
    func configDatabase(databaseName: String) {
        self.databaseName = databaseName
    }
    
    //open database
    func open() {
        print("open: \(databaseName)")
    }
    
    //save database
    func save() {
        print("save: \(databaseName)")
    }
}


DataManager.shared().open()























