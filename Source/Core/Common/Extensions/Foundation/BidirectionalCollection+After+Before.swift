//
//  BidirectionalCollection+After+Before.swift
//

import Foundation

extension BidirectionalCollection where Iterator.Element: Equatable {
    typealias Element = Self.Iterator.Element
    
    func after(_ item: Element, loop: Bool = false) -> Element? {
        guard let itemIndex = firstIndex(of: item) else { return nil }
        let isLast = index(after: itemIndex) == endIndex
        
        if loop && isLast {
            return first
        } else if isLast {
            return nil
        } else {
            return self[index(after: itemIndex)]
        }
    }
    
    func before(_ item: Element, loop: Bool = false) -> Element? {
        guard let itemIndex = firstIndex(of: item) else { return nil }
            let isFirst = itemIndex == startIndex
        
            if loop && isFirst {
                return last
            } else if isFirst {
                return nil
            } else {
                return self[index(before: itemIndex)]
            }
    }
}
