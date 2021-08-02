//
//  AlarmSettingView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/19.
//

import RxCocoa
import RxSwift
import UIKit

protocol AlarmSettingViewDelegate: AnyObject {
    func alarmSettingViewDidTapTime(_ alarmSettingView: AlarmSettingView)
}

class AlarmSettingView: UIView {
    
    weak var delegate: AlarmSettingViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bindTapGesture()
    }
    
    func updateDate(_ date: Date) {
        self.timeStampLabel.text = date.convertString(format: "a h시 mm분")
    }
    
    private func bindTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.alarmSettingViewDidTapTime(self)
        }).disposed(by: self.disposeBag)
        
        self.timeSetView.addGestureRecognizer(tapGesture)
    }
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeSetView: UIView!
    @IBOutlet private weak var timeStampLabel: UILabel!
    
}
