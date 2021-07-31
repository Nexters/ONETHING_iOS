//
//  BuildConfiguration.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/27.
//

import Foundation

enum BuildConfiguration {
    case release
    case debug
    
    static var current: BuildConfiguration {
        #if RELEASE
        return .release
        #else
        return .debug
        #endif
    }
}
