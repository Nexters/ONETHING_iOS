//
//  HabitImagesLayoutGuide.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 05/01/2023.
//

import UIKit

struct HabitImagesLayoutGuide {
    static var collectionViewFlowLayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.collectionViewItemSize
        flowLayout.sectionInset = self.collectionViewSectionInset
        flowLayout.minimumLineSpacing = self.collectionViewMinimumLineSpacing
        flowLayout.minimumInteritemSpacing = self.collectionViewMinimumInteritemSpacing
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }
    
    static var numberOfColumns: Int {
        return 3
    }
    
    private static var cellDiameter: CGFloat {
        let leftConstant = self.collectionViewSectionInset.left
        let rightConstant = self.collectionViewSectionInset.right
        let innerConstant: CGFloat = Self.collectionViewMinimumInteritemSpacing
        let totalInnerConstant = CGFloat(Self.numberOfColumns - 1) * innerConstant
        let totalWidthOfHabitsForRow: CGFloat = DeviceInfo.screenWidth - leftConstant - rightConstant - totalInnerConstant
        
        let cellDiameter = totalWidthOfHabitsForRow / CGFloat(self.numberOfColumns)
        return cellDiameter
    }
    
    static var collectionViewItemSize: CGSize {
        return CGSize(width: Self.cellDiameter, height: Self.cellDiameter)
    }
    
    static var collectionViewSectionInset: UIEdgeInsets {
        return .zero
    }
    
    static var collectionViewMinimumLineSpacing: CGFloat {
        return 2
    }
    
    static var collectionViewMinimumInteritemSpacing: CGFloat {
        return 2.67
    }
}

