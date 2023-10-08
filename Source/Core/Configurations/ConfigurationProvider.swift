//
//  Configuration.swift
//

import Foundation

enum ConfigurationProvider {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }

    static func getConfig() throws -> [String: String] {
        guard let object = Bundle.main.object(forInfoDictionaryKey: "BUILD_CONFIGURATION") else {
            throw Error.missingKey
        }

        switch object {
        case let value as [String: Any]:
            // swiftlint:disable:next force_cast
            return value.mapValues { $0 as! String }
        default:
            throw Error.invalidValue
        }
    }
}
