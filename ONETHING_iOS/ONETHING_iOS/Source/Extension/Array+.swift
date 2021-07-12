//
//  Array+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/13.
//

import Foundation

extension Array {
    
    subscript(safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
    
}
