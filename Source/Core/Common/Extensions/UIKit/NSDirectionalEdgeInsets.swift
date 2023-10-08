//
//  NSDirectionalEdgeInsets+Extensions.swift
//

import UIKit

extension NSDirectionalEdgeInsets {
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    static func uniform(size: CGFloat) -> NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(top: size, leading: size, bottom: size, trailing: size)
    }
    
    static func insets(horizontal: CGFloat, vertical: CGFloat) -> NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(horizontal: horizontal, vertical: vertical)
    }
    
    static func horizontal(_ value: CGFloat) -> NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(horizontal: value, vertical: .zero)
    }
    
    static func vertical(_ value: CGFloat) -> NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(horizontal: .zero, vertical: value)
    }
}
