//
//  UICollectionViewDataSource+.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/05.
//

import UIKit

extension UICollectionViewDataSource {
  static var defaultCellReuseIdentifier: String {
    return "UICollectionViewCell"
  }
  
  func defaultCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(withReuseIdentifier: Self.defaultCellReuseIdentifier, for: indexPath)
  }
}
