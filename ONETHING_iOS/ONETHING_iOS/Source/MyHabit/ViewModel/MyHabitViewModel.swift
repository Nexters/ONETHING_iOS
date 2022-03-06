//
//  MyHabitViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/02/27.
//

import RxSwift
import Foundation
import RxRelay

final class MyHabitViewModel {
    
    func occur(viewEvent: ViewEvent) {
        switch viewEvent {
        case .viewDidLoad:
            self.fetchHabitHistory()
        }
    }
    
    private func fetchHabitHistory() {
        
    }
    
    private let disposeBag = DisposeBag()
    
}

extension MyHabitViewModel {
    
    enum ViewEvent {
        case viewDidLoad
    }
    
}
