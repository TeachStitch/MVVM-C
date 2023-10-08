//
//  NetworkConnectionService.swift
//

import Combine
import Network

enum NetworkConnectionStatus: Equatable {
    /// The path has a usable route upon which to send and receive data
    case satisfied

    /// The path does not have a usable route. This may be due to a network interface being down, or due to system policy.
    case unsatisfied

    /// The path does not currently have a usable route, but a connection attempt will trigger network attachment.
    case requiresConnection
    
    public var isSatisfied: Bool {
        self == .satisfied
    }
}

protocol NetworkConnectionServiceHolder {
    var networkConnectionService: NetworkConnectionServiceProtocol { get }
}

protocol NetworkConnectionServiceProtocol {
    var publisher: AnyPublisher<NetworkConnectionStatus, Never> { get }
    var isActive: Bool { get }
    var status: NetworkConnectionStatus? { get }
    
    func startMonitoring()
    func stopMonitoring()
}

final class NetworkConnectionService: NetworkConnectionServiceProtocol {
    // MARK: - Properties
    private(set) var isActive: Bool
    private(set) var status: NetworkConnectionStatus?
    
    var publisher: AnyPublisher<NetworkConnectionStatus, Never> {
        subject.eraseToAnyPublisher()
    }
    
    private let pathMonitor: NWPathMonitor
    private let queue: DispatchQueue
    private let subject = PassthroughSubject<NetworkConnectionStatus, Never>()
    
    // MARK: - Initialization
    init(pathMonitor: NWPathMonitor = NWPathMonitor(), queue: DispatchQueue = DispatchQueue(label: "path.monitor.private.queue"), isActive: Bool = true) {
        self.pathMonitor = pathMonitor
        self.queue = queue
        self.isActive = isActive
        
        if isActive {
            pathMonitor.pathUpdateHandler = { [unowned self] path in
                switch path.status {
                case .satisfied:
                    status = .satisfied
                    subject.send(.satisfied)
                case .unsatisfied:
                    status = .unsatisfied
                    subject.send(.unsatisfied)
                case .requiresConnection:
                    status = .requiresConnection
                    subject.send(.requiresConnection)
                @unknown default:
                    status = .unsatisfied
                    subject.send(.unsatisfied)
                }
            }
            
            pathMonitor.start(queue: queue)
        }
    }
    
    deinit {
        pathMonitor.cancel()
    }
    
    // MARK: - Method(s)
    func startMonitoring() {
        guard !isActive else { return }
        
        pathMonitor.pathUpdateHandler = { [unowned self] path in
            switch path.status {
            case .satisfied:
                subject.send(.satisfied)
            case .unsatisfied:
                subject.send(.unsatisfied)
            case .requiresConnection:
                subject.send(.requiresConnection)
            @unknown default:
                subject.send(.unsatisfied)
            }
        }
        pathMonitor.start(queue: queue)
        
        isActive = true
    }
    
    func stopMonitoring() {
        guard isActive else { return }
        pathMonitor.cancel()
        isActive = false
    }
}
