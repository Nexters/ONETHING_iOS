//
//  UITableView+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import UIKit

extension UITableView {
    
    func registerCell<T: UITableViewCell>(cellType: T.Type) {
        let identifier = String(describing: T.self)
        let nib        = UINib(nibName: identifier, bundle: nil)
        
        if cellType.isExistNibFile { self.register(nib, forCellReuseIdentifier: identifier) }
        else                       { self.register(cellType, forCellReuseIdentifier: identifier) }
    }
    
    func dequeueReuableCell<T: UITableViewCell>(cell: T.Type, forIndexPath indexPath: IndexPath) -> T? {
        let identifier = String(describing: T.self)
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T
    }
    
}
