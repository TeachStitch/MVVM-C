//
//  Environment+Holders.swift
//

import Foundation

fileprivate extension Environment {
    enum Constants {
        static let errorMessage = "'%@' cannot be resolved"
    }
}

// MARK: - UserDefaultsServiceHolder
extension Environment: UserDefaultsServiceHolder {
    var userDefaultsService: UserDefaultsServiceProtocol {
        guard let userDefaultsService: UserDefaultsService = self.resolve() else {
            fatalError(.init(format: Constants.errorMessage,
                             arguments: [String(describing: UserDefaultsService.self)]))
        }
        
        return userDefaultsService
    }
}

// MARK: - KeychainServiceHolder
extension Environment: KeychainServiceHolder {
    var keychainService: KeychainServiceProtocol {
        guard let keychainService: KeychainServiceProtocol = self.resolve() else {
            fatalError(.init(format: Constants.errorMessage,
                             arguments: [String(describing: KeychainService.self)]))
        }
        
        return keychainService
    }
}
