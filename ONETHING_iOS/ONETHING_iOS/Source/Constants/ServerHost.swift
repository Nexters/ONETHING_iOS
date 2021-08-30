//
//  ServerHost.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/27.
//

import Foundation

struct ServerHost {
    
    static var main: String {
        switch BuildConfiguration.current {
        case .release: return "http://49.50.174.147:8080"
        case .debug: return "http://49.50.174.147:8090"
        }
    }
    
}
