//
//  ReusableView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import Foundation

import UIKit

protocol Reusable: AnyObject { }

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
