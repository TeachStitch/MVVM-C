//
//  Router.swift
//

import UIKit

protocol RouterProtocol: AnyObject {
    
    var rootController: UINavigationController { get }
    var transition: UIViewControllerAnimatedTransitioning? { get set }
    
    func present(_ viewController: UIViewController)
    func push(_ viewController: UIViewController)
}

extension RouterProtocol {
    func present(_ viewController: UIViewController) {
        present(viewController)
    }
    
    func present(_ viewController: UIViewController, animated: Bool = true, modalPresentationStyle: UIModalPresentationStyle = .automatic, completion: VoidClosure? = nil) {
        viewController.modalPresentationStyle = modalPresentationStyle
        rootController.present(viewController, animated: animated, completion: completion)
    }
    
    func push(_ viewController: UIViewController) {
        push(viewController)
    }
    
    func push(_ viewController: UIViewController, animated: Bool = true, transition: UIViewControllerAnimatedTransitioning? = nil, completion: VoidClosure? = nil) {
        guard !(viewController is UINavigationController) else {
            assertionFailure("Deprecated push UINavigationController.")
            return
        }
        
        self.transition = transition
        rootController.pushViewController(viewController, animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool = true, transition: UIViewControllerAnimatedTransitioning? = nil, completion: VoidClosure? = nil) {
        self.transition = transition
        rootController.popViewController(animated: animated, completion: completion)
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool = true, completion: VoidClosure? = nil) {
        rootController.popToViewController(viewController, animated: animated, completion: completion)
    }
    
    func dismissViewController(animated: Bool = true, completion: VoidClosure?) {
        rootController.dismiss(animated: animated, completion: completion)
    }
    
    func setRootViewController(_ viewController: UIViewController, animated: Bool = true, hidesNavigationBar: Bool = false, completion: VoidClosure? = nil) {
        rootController.setViewControllers([viewController], animated: animated, completion: completion)
        rootController.isNavigationBarHidden = hidesNavigationBar
    }
    
    @discardableResult
    func popToRootViewController(animated: Bool = true, completion: VoidClosure? = nil) -> UIViewController? {
        rootController.popToRootViewController(animated: animated, completion: completion)
        return rootController.viewControllers.first
    }
    
    func showNavigationBarTitle(animated: Bool = true) {
        rootController.navigationBar.prefersLargeTitles = false
        
        if rootController.isNavigationBarHidden {
            rootController.setNavigationBarHidden(false, animated: animated)
        }
    }

    func hideNavigationBarTitle(animated: Bool = true) {
        rootController.setNavigationBarHidden(true, animated: animated)
    }
}

final class Router: NSObject, RouterProtocol {
    // MARK: - Properties
    let rootController: UINavigationController
    var transition: UIViewControllerAnimatedTransitioning?
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        super.init()
        rootController.delegate = self
    }
}

// MARK: - UINavigationControllerDelegate
extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition
    }
}
