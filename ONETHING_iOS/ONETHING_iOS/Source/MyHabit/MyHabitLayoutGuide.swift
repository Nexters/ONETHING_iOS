//
//  MyHabitLayoutGuide.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/02/27.
//

import UIKit

struct MyHabitLayoutGuide {
    
    static var collectionViewFlowLayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.collectionViewItemSize
        flowLayout.sectionInset = self.collectionViewSectionInset
        flowLayout.minimumLineSpacing = self.collectionViewMinimumLineSpacing
        flowLayout.minimumInteritemSpacing = self.collectionViewMinimumInteritemSpacing
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }
    
    static var collectionViewItemSize: CGSize {
        let horizonInset: CGFloat = self.collectionViewSectionInset.left
        let ratio: CGFloat = 430 / 299                                      // HEIGHT : WIDTH (375pt 기준)
        
        let width = DeviceInfo.screenWidth - (2 * horizonInset)
        let height = width * ratio
        return CGSize(width: width, height: height)
    }
    
    static var collectionViewSectionInset: UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 38, bottom: 0, right: 38)
    }
    
    static var collectionViewMinimumLineSpacing: CGFloat {
        26
    }
    
    static var collectionViewMinimumInteritemSpacing: CGFloat {
        0
    }
    
}
