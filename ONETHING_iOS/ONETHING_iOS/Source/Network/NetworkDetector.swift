//
//  NetworkDetector.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/02/24.
//

import Foundation
import Network

final class NetworkDetector {
    
    static let shared = NetworkDetector()
    
    var isConnected: Bool {
        self.connectionType.isConnected
    }
    
    func startMonitor() {
        self.monitor.start(queue: .global())
        self.monitor.pathUpdateHandler = { path in
            
        }
    }
    
    private init(monitor: NWPathMonitor = NWPathMonitor()) {
        self.monitor = monitor
    }
    
    private(set) var connectionType: NetworkConnection = NetworkConnection(rawValue: 0)
    
    private let monitor: NWPathMonitor
    
}

struct NetworkConnection: OptionSet {
    
    let rawValue: Int
    
    static let wifi = NetworkConnection(rawValue: 1 << 0)
    static let cellular = NetworkConnection(rawValue: 1 << 1)
    static let ethernet = NetworkConnection(rawValue: 1 << 2)
    static let loopback = NetworkConnection(rawValue: 1 << 3)
    static let unknown = NetworkConnection(rawValue: 1 << 4)
    
    var isConnected: Bool {
        return self.isEmpty == false
    }
    
}