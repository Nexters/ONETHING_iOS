//
//  HabitStampView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/21.
//

import UIKit

final class HabitStampView: UICollectionView {
    static let defaultTotalCellNumbers = 12
    weak var prevCheckedCell: HabitStampCell?
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.clipsToBounds = false
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var cellSize: CGSize {
        return CGSize(width: 46, height: 46)
    }
    
    var outerConstant: CGFloat {
        return 50
    }
    
    func hideCircleCheckViewOfPrevCell() {
        self.prevCheckedCell?.hideCheckView()
    }
}
