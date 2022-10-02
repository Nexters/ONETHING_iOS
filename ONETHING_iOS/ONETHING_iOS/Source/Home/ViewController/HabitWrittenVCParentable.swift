//
//  HabitWrittenVCParentable.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 02/10/2022.
//

import UIKit

protocol HabitWrittentVCParentable: UIViewController {
    var backgroundDimView: BackgroundDimView { get }
    
    func showDimView()
    func hideDimView()
    func addDimTapGestureRecognizer(_ tapGestureRecognizer: UITapGestureRecognizer)
    func removeDimRecognizer()
}

extension HabitWrittentVCParentable {
    func showDimView() {
        self.backgroundDimView.showCrossDissolve(completedAlpha: BackgroundDimView.completedAlpha)
    }
    
    func hideDimView() {
        self.backgroundDimView.hideCrossDissolve()
    }
    
    func addDimTapGestureRecognizer(_ tapGestureRecognizer: UITapGestureRecognizer) {
        self.backgroundDimView.addTapGestureRecognizer(tapGestureRecognizer)
    }
    
    func removeDimRecognizer() {
        self.backgroundDimView.removeTapGestureRecognizer()
    }
}
