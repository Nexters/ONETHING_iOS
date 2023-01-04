//
//  HabitDocumentsViewController.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 05/01/2023.
//

import UIKit

final class HabitDocumentsViewController: UIViewController, HabitHistorySubViewController {
    weak var delegate: HabitHistorySubViewControllerDelegate?
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: HabitDocumentsLayoutGuide.collectionViewFlowLayout
    )
    let viewModel: HabitHistoryViewModel
    
    init(viewModel: HabitHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
