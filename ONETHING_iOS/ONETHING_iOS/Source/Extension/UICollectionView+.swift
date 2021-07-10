//
//  UICollectionView+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import UIKit

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(cellType: T.Type) {
        let identifier = String(describing: T.self)
        let nib        = UINib(nibName: identifier, bundle: nil)
        
        if cellType.isExistNibFile { self.register(nib, forCellWithReuseIdentifier: identifier) }
        else                       { self.register(cellType, forCellWithReuseIdentifier: identifier) }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(cell: T.Type, forIndexPath indexPath: IndexPath) -> T? {
        let identifier = String(describing: cell)
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T
    }
    
}
