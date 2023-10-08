//
//  Environment.swift
//

import Foundation

final class Environment {
    private var services = [ObjectIdentifier: Any]()
    
    func register<T>(_ service: T) {
        services[key(for: T.self)] = service
    }
    
    func resolve<T>() -> T? {
        services[key(for: T.self)] as? T
    }
}

// MARK: - Private
private extension Environment {
    func key<T>(for type: T.Type) -> ObjectIdentifier {
        ObjectIdentifier(T.self)
    }
}
