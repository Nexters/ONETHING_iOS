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
    
    func updateShareHabit(_ habit: MyHabitCellPresentable) {
        self.firstTypeContentView.updateShareHabit(habit)
        self.secondTypeContentView.updateShareHabit(habit)
    }
    
    func updateShareType(_ type: HabitShareUIType) {
        switch type {
        case .first, .second:
            self.firstTypeContentView.shareUIType = type
            self.firstTypeContentView.isHidden = false
            self.secondTypeContentView.isHidden = true
        case .third, .fourth:
            self.secondTypeContentView.shareUIType = type
            self.firstTypeContentView.isHidden = true
            self.secondTypeContentView.isHidden = false
        }
    }
    
    private func setupUI() {
        self.firstTypeContentView.isHidden = true
        self.addSubview(self.firstTypeContentView)
        self.addSubview(self.secondTypeContentView)
    }
    
    private func setupLayout() {
        self.firstTypeContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.secondTypeContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private let firstTypeContentView = MyHabitShareFirstTypeView(frame: .zero)
    private let secondTypeContentView = MyHabitShareSecondTypeView(frame: .zero)
    
}
