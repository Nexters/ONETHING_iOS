//
//  MyHabitShareContentView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/06.
//

import SnapKit
import Then
import UIKit

class MyHabitShareContentView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(self.firstTypeContentView)
    }
    
    private func setupLayout() {
        self.firstTypeContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private let firstTypeContentView = MyHabitShareFirstTypeView(frame: .zero)
    
}
