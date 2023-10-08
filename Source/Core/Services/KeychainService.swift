//
//  KeychainService.swift
//

import Foundation

protocol KeychainServiceHolder {
    var keychainService: KeychainServiceProtocol { get }
}

protocol KeychainServiceProtocol {
    func save<T>(_ item: T, service: String, account: String) where T : Codable
    func read<T>(service: String, account: String, type: T.Type) -> T? where T : Codable
    func delete(service: String, account: String)
}

final class KeychainService {
    // MARK: - Properties
    static let standard: KeychainServiceProtocol = KeychainService()

    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()
    
    private init() {}

    // MARK: - Method(s)
    func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as [CFString : Any] as CFDictionary

        // Add data in query to keychain
        let status = SecItemAdd(query, nil)

        if status == errSecDuplicateItem {
            // Item already exist, thus update it.
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as [CFString : Any] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary

            // Update existing item
            SecItemUpdate(query, attributesToUpdate)
        }
    }

    func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)

        return (result as? Data)
    }
}

// MARK: - KeychainServiceProtocol
extension KeychainService: KeychainServiceProtocol {

    func save<T>(_ item: T, service: String, account: String) where T : Codable {
        do {
            // Encode as JSON data and save in keychain
            let data = try encoder.encode(item)
            save(data, service: service, account: account)

        } catch {
            assertionFailure("Fail to encode item for keychain: \(error)")
        }
    }

    func read<T>(service: String, account: String, type: T.Type) -> T? where T : Codable {
        // Read item data from keychain
        guard let data = read(service: service, account: account) else {
            return nil
        }

        // Decode JSON data to object
        do {
            let item = try decoder.decode(type, from: data)
            return item
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
    }

    func delete(service: String, account: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any] as CFDictionary

        // Delete item from keychain
        SecItemDelete(query)
    }
}
