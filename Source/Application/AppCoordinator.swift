//
//  AppCoordinator.swift
//

import UIKit
import Combine

typealias ApplicationEnvironment = UserDefaultsServiceHolder & KeychainServiceHolder

final class AppCoordinator: BaseCoordinator {
    // MARK: - Properties
    let window: UIWindow
    let environment: ApplicationEnvironment
    
    init(window: UIWindow, environment: some ApplicationEnvironment, router: some RouterProtocol) {
        self.environment = environment
        self.window = window
        super.init(router: router)
    }
    
    override func start() {
        window.rootViewController = router.rootController
        window.makeKeyAndVisible()
    }
}

// MARK: - Private
private extension AppCoordinator {
    
}
