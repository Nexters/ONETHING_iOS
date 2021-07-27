//
//  DispatchQueue+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/27.
//

import Foundation

extension DispatchQueue {
    static let onethingNetworkQueue = DispatchQueue(label: "com.nexters.onething.network")
    
    static func executeAync(on queue: DispatchQueue, execute: @escaping () -> Void) {
        queue.async(execute: execute)
    }
    
    static func executeAyncAfter(on queue: DispatchQueue, deadline: DispatchTime, execute: @escaping () -> Void) {
        queue.asyncAfter(deadline: deadline, execute: execute)
    }
}
