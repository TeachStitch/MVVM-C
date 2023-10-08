//
//  Optional+DefaultValues.swift
//

import Foundation

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool { self?.isEmpty ?? true }
}

extension Optional where Wrapped == String {
    var orEmpty: Wrapped {
        self ?? ""
    }
}

extension Optional where Wrapped == Int {
    var orZero: Wrapped {
        self ?? .zero
    }
    
    var isNilOrZero: Bool { self.orZero == .zero }
}

extension Optional where Wrapped == Double {
    var orZero: Wrapped {
        self ?? .zero
    }
    
    var isNilOrZero: Bool { self.orZero == .zero }
}

extension Optional where Wrapped: NSAttributedString {
    var orEmpty: Wrapped {
        self ?? .init()
    }
}
