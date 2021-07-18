//
//  UserDefaultWrapper.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/18.
//

import Foundation

@propertyWrapper struct UserDefaultWrapper<T> {
    
    var wrappedValue: T? {
        get {
            return UserDefaults.standard.object(forKey: self.key) as? T
        }
        
        set {
            if newValue == nil { UserDefaults.standard.removeObject(forKey: key) }
            else { UserDefaults.standard.setValue(newValue, forKey: key) }
        }
    }
    
    init(key: String) {
        self.key = key
    }
    
    private let key: String
    
}
