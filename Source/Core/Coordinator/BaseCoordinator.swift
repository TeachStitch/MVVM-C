//
//  BaseCoordinator.swift
//

import UIKit
import Combine

protocol Coordinator {
    var didFinishPublisher: AnyPublisher<Void, Never> { get }
    
    func start()
}

class BaseCoordinator: Coordinator {
    // MARK: - Properties
    let router: RouterProtocol
    let didFinishSubject = PassthroughSubject<Void, Never>()
    var cancellables = Set<AnyCancellable>()
    
    var didFinishPublisher: AnyPublisher<Void, Never> {
        didFinishSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    init(router: some RouterProtocol) {
        self.router = router
    }
    
    // MARK: - Method(s)
    func start() {
        assertionFailure("You should override this method")
    }
}
