//
//  FileIOController.swift
//  WorkingWithFiles
//
//  Created by Tien Le P. VN.Danang on 3/8/22.
//

import Foundation

struct FileIOController {
    var manager = FileManager.default

    func write<T: Encodable>(
        _ object: T,
        toDocumentNamed documentName: String,
        encodedUsing encoder: JSONEncoder = .init()
    ) throws {
        let rootFolderURL = try manager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )

        let nestedFolderURL = rootFolderURL.appendingPathComponent("MyAppFiles")
        
        if !manager.fileExists(atPath: nestedFolderURL.relativePath) {
            try manager.createDirectory(
                at: nestedFolderURL,
                withIntermediateDirectories: false,
                attributes: nil
            )
        }

        let fileURL = nestedFolderURL.appendingPathComponent(documentName)
        print("File URL: \(fileURL.path)")
        let data = try encoder.encode(object)
        try data.write(to: fileURL)
    }
    
}
