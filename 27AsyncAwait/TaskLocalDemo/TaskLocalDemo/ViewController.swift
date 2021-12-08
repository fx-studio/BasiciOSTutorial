//
//  ViewController.swift
//  TaskLocalDemo
//
//  Created by Tien Le P. VN.Danang on 12/7/21.
//

import UIKit

class ViewController: UIViewController {
    
    @TaskLocal static var currentName: String?
    
    var name: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        Task {
            self.name = "Fx Studio"
            self.printName()
            
            Task {
                self.name = "Fx Studio 2"
                self.printName()
            }
        }
        
        Task.detached {
            self.name = "Fx Studio 3"
            self.printName()
        }
         */
        
        
        Self.$currentName.withValue("Fx Studio") {
            Task {
                print("#1 - 0")
                await asyncPrintName() // Fx Studio
                
                Task {
                    print("#1 - 1")
                    await asyncPrintName() // Fx Studio
                    
                    //update
                    await Self.$currentName.withValue("Fx Studio 2") {
                        print("#1 - 1 - 1")
                        await asyncPrintName() // Fx Studio 2
                    }
                    
                    print("#1 - 1 - 2")
                    await asyncPrintName() // Fx Studio

                }
        
                
                Task {
                    sleep(2)
                    print("#1 - 2")
                    await asyncPrintName() // Fx Studio
                }
            }
            
            Task.detached {
                print("#3 - 0")
                await asyncPrintName() // Noname

                await Self.$currentName.withValue("Fx Studio 3", operation: {
                    print("#3 - 1")
                    await asyncPrintName() // Fx Studio 3
                })
            }
        }
        
        Task {
            print("#4 - 0")
            await asyncPrintName() //Noname
        }
    }

    func printName() {
        if let name = self.name {
            print("Name is \(name)")
        } else {
            print("Nomane")
        }
    }

}

func asyncPrintName() async {
    if let name = await ViewController.currentName {
        print("Current Name is \(name)")
    } else {
        print("Nomane")
    }
}

