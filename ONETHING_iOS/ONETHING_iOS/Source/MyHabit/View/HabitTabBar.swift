//
//  HabitTabBar.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 04/01/2023.
//

import UIKit

import RxSwift
import RxCocoa

protocol HabitTabBarDelegate: AnyObject {
    func foo()
}

final class HabitTabBar: UIView {
    private(set) var currentIndex: Int = 0 {
        didSet {
            self.updateTabButtons()
        }
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private lazy var tabButtons: [HabitTabButton] = HabitTabMenu.allCases.enumerated().map { index, menu in
        let tabButton = HabitTabButton(normalImage: menu.deactiveImage, selectedImage: menu.activeImage)
        tabButton.isSelected = index == self.currentIndex
        tabButton.rx.tap
            .map { index }
            .withUnretained(self)
            .subscribe(onNext: { owner, index in
                owner.currentIndex = index
                owner.delegate?.foo()
            })
            .disposed(by: self.disposeBag)
        
        return tabButton
    }
    
    private let disposeBag = DisposeBag()
    weak var delegate: HabitTabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupStackView()
        self.setupButtons()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupStackView() {
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
            make.height.equalTo(56)
        })
    }
    
    private func setupButtons() {
        for tabButton in self.tabButtons {
            self.stackView.addArrangedSubview(tabButton)
        }
    }

    private func updateTabButtons() {
        self.tabButtons.enumerated().forEach({ index, tabButton in
            tabButton.isSelected = index == self.currentIndex
        })
    }
}

enum HabitTabMenu: CaseIterable {
    case stamp
    case photo
    case document
    
    var activeImage: UIImage? {
        switch self {
        case .stamp:
            return UIImage(named: "stamp_active")
        case .photo:
            return UIImage(named: "image_active")
        case .document:
            return UIImage(named: "document_active")
        }
    }
    
    var deactiveImage: UIImage? {
        switch self {
        case .stamp:
            return UIImage(named: "stamp_inactive")
        case .photo:
            return UIImage(named: "image_inactive")
        case .document:
            return UIImage(named: "document_inactive")
        }
    }
}
