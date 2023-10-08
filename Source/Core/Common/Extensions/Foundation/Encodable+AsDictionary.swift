//
//  Encodable+AsDictionary.swift
//

import Foundation

extension Encodable {
    func asDictionary(options: JSONSerialization.ReadingOptions = .fragmentsAllowed) throws -> [String: Any] {        
        let data = try JSONEncoder().encode(self)
        
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: options) as? [String: Any] else {
            throw NSError()
        }
        
        return dictionary
    }
}
