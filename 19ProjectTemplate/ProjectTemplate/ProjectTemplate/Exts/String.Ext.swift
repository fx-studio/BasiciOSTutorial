//
//  String.Ext.swift
//  ProjectTemplate
//
//  Created by Le Phuong Tien on 12/19/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import Foundation

enum Process {
    case encode
    case decode
}

extension String {

    var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func base64(_ method: Process) -> String? {
        switch method {
        case .encode:
            guard let data = data(using: .utf8) else { return nil }
            return data.base64EncodedString()
        case .decode:
            guard let data = Data(base64Encoded: self) else { return nil }
            return String(data: data, encoding: .utf8)
        }
    }
}

extension String {

    /// Initializes an NSURL object with a provided URL string. (read-only)
    var url: URL? {
        return URL(string: self)
    }

    /// The host, conforming to RFC 1808. (read-only)
    var host: String {
        if let url = url, let host = url.host {
            return host
        }
        return ""
    }
}
