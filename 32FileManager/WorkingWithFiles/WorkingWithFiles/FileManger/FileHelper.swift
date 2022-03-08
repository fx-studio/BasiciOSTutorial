//
//  FileHelper.swift
//  WorkingWithFiles
//
//  Created by Tien Le P. VN.Danang on 3/7/22.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func getDocumentFilePath(fileName: String) -> URL {
    let documentPath = getDocumentsDirectory()
    let filePath = documentPath.appendingPathComponent(fileName)
    
    return filePath
}

func checkFileExist(fileName: String) -> Bool {
    let filePath = getDocumentFilePath(fileName: fileName)
    let fileManger = FileManager.default
    
    if fileManger.fileExists(atPath: filePath.path) {
        print("FILE: \(fileName) is AVAILABLE")
        return true
    } else {
        print("FILE: \(fileName) NOT AVAILABLE")
        return false
    }
}


func readFile(fileName: String) -> Data? {
    if checkFileExist(fileName: fileName) {
        let filePath = getDocumentFilePath(fileName: fileName)
        do {
            let data = try Data(contentsOf: filePath)
            return data
        } catch {
            print("Can not read file")
            return nil
        }
    } else {
        print("File not available.")
        return nil
    }
}

func writeFile(fileName: String, content: Data) -> Bool {
    let filePath = getDocumentFilePath(fileName: fileName)
    
    do {
        try content.write(to: filePath)
        return true
        
    } catch {
        print("Can not write file")
        return false
    }
}

