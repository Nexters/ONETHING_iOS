//
//  HabitHistoryLayoutGuide.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 02/10/2022.
//

import UIKit

struct HabitHistoryLayoutGuide {
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
        return 5
    }
    
    private static var cellDiameter: CGFloat {
        let leftConstant = self.collectionViewSectionInset.left
        let rightConstant = self.collectionViewSectionInset.right
        let innerConstant: CGFloat = 20.0
        let totalInnerConstant = CGFloat(Self.numberOfColumns - 1) * innerConstant
        let totalWidthOfHabitsForRow: CGFloat = DeviceInfo.screenWidth - leftConstant - rightConstant - totalInnerConstant
        
        let cellDiameter = totalWidthOfHabitsForRow / CGFloat(self.numberOfColumns)
        return cellDiameter
    }
    
    static var collectionViewItemSize: CGSize {
        return CGSize(width: Self.cellDiameter, height: Self.cellDiameter)
    }
    
    static var collectionViewSectionInset: UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 32, bottom: 30, right: 32)
    }
    
    static var collectionViewMinimumLineSpacing: CGFloat {
        return 20
    }
    
    static var collectionViewMinimumInteritemSpacing: CGFloat {
        return 20
    }
}
