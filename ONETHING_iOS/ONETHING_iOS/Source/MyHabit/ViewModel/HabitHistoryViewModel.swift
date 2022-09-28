//
//  HabitHistoryViewModel.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 12/09/2022.
//

import Foundation

final class HabitHistoryViewModel {
    private(set) var presentable: MyHabitCellPresentable?
    let habitInfoViewModel: HabitInfoViewModel
    
    init(presentable: MyHabitCellPresentable?) {
        self.presentable = presentable
        self.habitInfoViewModel = HabitInfoViewModel(presentable: presentable)
    }
}
