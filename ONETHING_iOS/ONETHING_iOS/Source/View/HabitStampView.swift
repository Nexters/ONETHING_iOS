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
    
    enum Stamp: CaseIterable {
        case beige
        case yellow
        case gray
        case red
        case pink_2
        case pink_1
        case purple_1
        case purple_2
        case blue
        case mint
        case green_2
        case green_1
        
        var image: UIImage {
            switch self {
            case .beige:
                return UIImage(named: "stamp_beige_70")!
            case .yellow:
                return UIImage(named: "stamp_yellow_70")!
            case .gray:
                return UIImage(named: "stamp_gray_70")!
            case .red:
                return UIImage(named: "stamp_red_70")!
            case .pink_2:
                return UIImage(named: "stamp_pink_2_70")!
            case .pink_1:
                return UIImage(named: "stamp_pink_1_70")!
            case .purple_1:
                return UIImage(named: "stamp_purple_1_70")!
            case .purple_2:
                return UIImage(named: "stamp_purple_2_70")!
            case .blue:
                return UIImage(named: "stamp_blue_70")!
            case .mint:
                return UIImage(named: "stamp_mint_70")!
            case .green_2:
                return UIImage(named: "stamp_green_2_70")!
            case .green_1:
                return UIImage(named: "stamp_green_1_70")!
            }
        }
    }
}
