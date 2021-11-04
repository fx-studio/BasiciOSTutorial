//
//  ViewController.swift
//  DemoProjectAsync
//
//  Created by Tien Le P. VN.Danang on 11/2/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Task {
            await printStudentInfo4()
        }
        
//        Task {
//            await printStudentInfo2()
//        }
    }

    func doSomething() async {
        print("ahihi")
    }
    
    // MARK: Define
    enum MyError: Error {
        case anError
    }
    
    struct Student {
        var name: String
        var classes: [String]
        var scores: [Int]
    }

    // MARK: function #1
    func getStudentName() async -> String {
        await Task.sleep(1_000_000_000)
        return "Fx Studio"
    }

    func getClasses() async -> [String] {
        await Task.sleep(1_000_000_000)
        return ["A", "B", "C", "D", "E", "F"]
    }

    func getScores() async -> [Int] {
        await Task.sleep(1_000_000_000)
        return [10, 9, 7, 8, 9, 9]
    }
    
    func getClassesAndScores() async -> ([String], [Int]) {
        async let classes = getClasses()
        async let scores = getScores()
        
        return await (classes, scores)
    }
    
    // MARK: function #2
    func getStudentName2() async throws -> String {
        await Task.sleep(1_000_000_000)
        return "Fx Studio"
    }

    func getClasses2() async throws -> [String] {
        throw MyError.anError
        //await Task.sleep(1_000_000_000)
        //return ["A", "B", "C", "D", "E", "F"]
    }

    func getScores2() async throws -> [Int] {
//        try Task.checkCancellation()
//        await Task.sleep(1_000_000_000)
//        print("getScores2 calling")
//        return [10, 9, 7, 8, 9, 9]
        
        await Task.sleep(1_000_000_000)
        if Task.isCancelled {
            return [10, 9, 7, 8, 9, 9]
        } else {
            print("getScores2 will cancel")
            throw MyError.anError
        }
    }
    
    // MARK: async let
    func printStudentInfo() async {
        print("\(Date()): get name")
        let name = await getStudentName()
        print("\(Date()): get classes")
        let classes = await getClasses()
        print("\(Date()): get score")
        let scores = await getScores()
        
        print("\(Date()): Creating ....")
        let student = Student(name: name, classes: classes, scores: scores)
        print("\(Date()): \(student.name) - \(student.classes) - \(student.scores)")
    }
    
    func printStudentInfo2() async {
        print("\(Date()): get name")
        async let name = getStudentName()
        print("\(Date()): get classes")
        async let classes = getClasses()
        print("\(Date()): get scores")
        async let scores = getScores()
        
        print("\(Date()): Creating ....")
        let student = await Student(name: name, classes: classes, scores: scores)
        print("\(Date()): \(student.name) - \(student.classes) - \(student.scores)")
    }
    
    func printStudentInfo3() async {
        print("\(Date()): get name")
        async let name = getStudentName()
        print("\(Date()): get classes & scores")
        async let results = getClassesAndScores()
        
        print("\(Date()): Creating ....")
        let student = await Student(name: name, classes: results.0, scores: results.1)
        print("\(Date()): \(student.name) - \(student.classes) - \(student.scores)")
    }
    
    func printStudentInfo4() async {
        do {
            print("\(Date()): get name")
            async let name = getStudentName2()
            print("\(Date()): get classes")
            async let classes = getClasses2()
            print("\(Date()): get scores")
            async let scores = getScores2()
            
            print("\(Date()): Creating ....")
            let student = try await Student(name: name, classes: classes, scores: scores)
            print("\(Date()): \(student.name) - \(student.classes) - \(student.scores)")
        } catch {
            print("Error: \(error)")
        }
    }

}

