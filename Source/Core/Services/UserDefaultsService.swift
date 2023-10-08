//
//  UserDefaultsService.swift
//

import Foundation
import Combine

protocol UserDefaultsServiceHolder {
    var userDefaultsService: UserDefaultsServiceProtocol { get }
}

protocol UserDefaultsServiceProtocol: AnyObject {
    
}

final class UserDefaultsService: UserDefaultsServiceProtocol {
    // MARK: - Properties
    static let shared: UserDefaultsServiceProtocol = UserDefaultsService()
    
    // MARK: - Initialization
    private init() {}
}

extension UserDefaultsService {
    @propertyWrapper
    struct Storage<T: Codable> {
        private let key: String
        private let defaultValue: T
        private let publisher = PassthroughSubject<T, Never>()
        
        init(key: String, defaultValue: T) {
            self.key = key
            self.defaultValue = defaultValue
        }
        
        var wrappedValue: T {
            get {
                let object = UserDefaults.standard.object(forKey: key)
                
                if let data = object as? Data,
                   let value = try? JSONDecoder().decode(T.self, from: data) {
                    return value
                } else if let value = object as? T {
                    return value
                } else {
                    return defaultValue
                }
            }
            set {
                let data = try? JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: key)
                publisher.send(newValue)
            }
        }
        
        var projectedValue: AnyPublisher<T, Never> {
            publisher.eraseToAnyPublisher()
        }
    }
}
