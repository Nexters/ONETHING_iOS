//
//  CardView.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 12/09/2022.
//

import UIKit

final class CardView: UIView {
    private var imageView: UIImageView?
    private let habitInfoViewModel: HabitInfoViewModel
    private let myHabitInfoView = MyHabitInfoView()
    
    init(with targetView: UIView, habitInfoViewModel: HabitInfoViewModel) {
        self.habitInfoViewModel = habitInfoViewModel
        super.init(frame: targetView.convert(targetView.frame, to: nil))
        
        self.configureImageView(with: targetView)
        self.configureMyHabitInfoView(with: habitInfoViewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func convertToInfoView() {
        self.myHabitInfoView.showCrossDissolve()
        self.imageView?.isHidden = true
        self.updateFrameToInfoViewVersion()
    }
    
    private func updateFrameToInfoViewVersion() {
        self.frame = CGRect(
            x: 0,
            y: 0,
            width: DeviceInfo.screenWidth,
            height: DeviceInfo.screenWidth * 0.6
        )
    }
    
    private func configureImageView(with targetView: UIView) {
        guard let copyImage = targetView.asImage() else { return }
        
        let copyImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            $0.cornerRadius = targetView.cornerRadius
            $0.clipsToBounds = false
            $0.image = copyImage
        }
        
        self.addSubview(copyImageView)
        copyImageView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        self.imageView = copyImageView
    }
    
    private func configureMyHabitInfoView(with habitInfoViewModel: HabitInfoViewModel) {
        self.myHabitInfoView.do {
            $0.isHidden = true
            $0.update(with: habitInfoViewModel)
        }
        
        self.addSubview(self.myHabitInfoView)
        self.myHabitInfoView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
        })
    }
}
