//
//  ViewController.swift
//  WorkingWithFiles
//
//  Created by Tien Le P. VN.Danang on 3/7/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // MARK: - 01 Get Bundle Resources Path
        let filePath = Bundle.main.url(forResource: "hello_file", withExtension: "txt")
        print("File path: \(filePath?.absoluteString ?? "n/a")")
        
        let path = Bundle.main.path(forResource: "hello_file", ofType: "txt")
        print("Path: \(path ?? "n/a")")
        
        // MARK: - 02 Get Documents Directory Path
        print("Documents Directory Path: \(getDocumentsDirectory().absoluteString)")
        
        // MARK: - 03 Append Path Component
        print("Append Path Component:  \(getDocumentFilePath(fileName: "hello.txt"))")
        
        // MARK: - 04 Check Exists File
        print("Check is Exists: \(checkFileExist(fileName: "data.json"))")
        
        // MARK: - 05 Read file
        guard let txtFileURL = Bundle.main.url(forResource: "hello_file", withExtension: "txt") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: txtFileURL)
            let content = String(data: data, encoding: .utf8)
            
            //let content = try String(contentsOf: txtFileURL)
            print("Content File: \(content)")
        } catch {
            print(error.localizedDescription)
        }
                
        // MARK: - 06
        let stringContent = "Hello, I am supperman!"
        let fileName = "superman.txt"
        
        if let stringData = stringContent.data(using: .utf8) {
            let okay = writeFile(fileName: fileName, content: stringData)
            if okay {
                print("DONE")
            } else {
                print("FAILED")
            }
        }
        
        if let dataFile = readFile(fileName: fileName) {
            let content = String(data: dataFile, encoding: .utf8) ?? "n/a"
            print("File: \(fileName) : \(content)")
        }
        
        // MARK: - 07 Attributes
        
        let fileSupperManPath = getDocumentFilePath(fileName: "superman.txt").path
        do {
            let fileManager = FileManager.default
            let attributes = try fileManager.attributesOfItem(atPath: fileSupperManPath)
            print("File Attributes:")
            for item in attributes {
                print(item)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // MARK: - 08 Custom Folder
        let fileIO = FileIOController()
        let fileContent = "Custom Folder"
        let customFileName = "abc.txt"
        
        do {
            try fileIO.write(fileContent, toDocumentNamed: customFileName)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }

}

