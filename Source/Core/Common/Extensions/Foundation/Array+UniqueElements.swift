//
//  Array+UniqueElements.swift
//

import Foundation

extension Array where Element: Equatable {
    func uniqueElements() -> [Element] {
        var out = [Element]()
        
        for element in self {
            if !out.contains(element) {
                out.append(element)
            }
        }
        
        return out
    }
    
    mutating func removeDuplicates() {
        self = self.uniqueElements()
    }
}
