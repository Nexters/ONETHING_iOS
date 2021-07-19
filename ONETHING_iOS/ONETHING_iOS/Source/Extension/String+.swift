//
//  String+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/19.
//

import Foundation

extension String {
    
    func range(of subString: String) -> NSRange? {
        return (self as NSString).range(of: subString)
    }
    
}
