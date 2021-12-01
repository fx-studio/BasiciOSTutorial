//
//  Typing.swift
//  AsyncSequenceDemo
//
//  Created by Tien Le P. VN.Danang on 12/1/21.
//

import Foundation

struct Typing: AsyncSequence {
    typealias Element = String
    
    let phrase: String
    
    struct AsyncIterator: AsyncIteratorProtocol {
        
        var index: String.Index
        let phrase: String
        
        init(_ phrase: String) {
            self.phrase = phrase
            self.index = phrase.startIndex
        }
        
        mutating func next() async throws -> String? {
            guard index < phrase.endIndex else {
                return nil
            }
            
            await Task.sleep(1_000_000_000) //nano sec
            
            defer {
                index = phrase.index(after: index)
            }
            
            return String(phrase[phrase.startIndex...index])
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(phrase)
    }
}
