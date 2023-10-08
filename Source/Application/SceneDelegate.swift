//
//  SceneDelegate.swift
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties
    // swiftlint:disable:next force_cast
    var appCoordinator: AppCoordinator!
    var window: UIWindow?

    // MARK: - Method(s)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        appCoordinator = AppCoordinator(window: window, environment: Environment(), router: Router(rootController: UINavigationController()))
        appCoordinator.start()
    }
}
