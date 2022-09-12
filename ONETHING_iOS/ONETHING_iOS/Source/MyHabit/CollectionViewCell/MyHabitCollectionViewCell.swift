//
//  MyHabitCollectionViewCell.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/02/27.
//

import RxSwift
import RxCocoa
import SnapKit

import UIKit

protocol MyHabitCollectionViewCellDelegate: AnyObject {
    func myhabitCollectionViewCellDidTap(_ cell: MyHabitCollectionViewCell)
    func myhabitCollectionViewCell(_ cell: MyHabitCollectionViewCell, didTapShare habit: MyHabitCellPresentable)
}

class MyHabitCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: MyHabitCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.layoutUI()
        self.bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.titleDescriptionLabel.text = ""
        self.progressDurationLabel.text = ""
        self.successRateLabel.text = ""
    }
    
    func configure(presentable: MyHabitCellPresentable, index: Int) {
        self.presentable = presentable
        self.updateLabelText(asPresentable: presentable, index: index)
        self.updateUI(asPresentable: presentable)
    }
    
    private func setupUI() {
        self.do {
            $0.clipsToBounds = false
            $0.layer.masksToBounds = false
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
            $0.layer.shadowRadius = 10
            $0.layer.shadowPath = UIBezierPath(rect: $0.bounds).cgPath
            $0.layer.rasterizationScale = 1.0
        }
        
        self.contentView.do {
            $0.cornerRadius = 16
            $0.backgroundColor = .black_100
        }
        
        self.titleDescriptionLabel.do {
            $0.textColor = .white
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 12)
            
            guard let userName = OnethingUserManager.sharedInstance.currentUser?.account?.name else { return }
            let index = 1
            $0.text = String(format: "%@ 님의 %@번째 성공 습관", arguments: [userName, "\(index)"])
        }
        
        self.titleLabel.do {
            $0.textColor = .white
            $0.font = UIFont.createFont(type: .pretendard(weight: .bold), size: 26)
            $0.text = "책 읽기"
        }
        
        self.nextImageView.do {
            $0.image = UIImage(named: "arrow_back")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .white
            $0.transform = CGAffineTransform(rotationAngle: .pi)
        }
        
        self.firstVerticalBorderView.do {
            $0.backgroundColor = .black_80
        }
        
        self.secondVerticalBorderView.do {
            $0.backgroundColor = .black_80
        }
        
        self.progressDurationDescriptionLabel.do {
            $0.textColor = .white
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 12)
            $0.text = "진행 기간"
        }
        
        self.progressDurationLabel.do {
            $0.textColor = .white
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 12)
            $0.textAlignment = .right
        }
        
        self.successRateDescriptionLabel.do {
            $0.textColor = .white
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 12)
            $0.text = "성공률"
        }
        
        self.successRateLabel.do {
            $0.textColor = .white
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 12)
            $0.textAlignment = .right
        }
        
        self.shareButton.do {
            $0.cornerRadius = 45 / 2
            $0.setImage(UIImage(named: "share_button"), for: .normal)
            $0.backgroundColor = .gray
        }
        
        self.contentView.addSubview(self.titleDescriptionLabel)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.nextImageView)
        self.contentView.addSubview(self.firstVerticalBorderView)
        self.contentView.addSubview(self.secondVerticalBorderView)
        self.contentView.addSubview(self.progressDurationDescriptionLabel)
        self.contentView.addSubview(self.progressDurationLabel)
        self.contentView.addSubview(self.successRateDescriptionLabel)
        self.contentView.addSubview(self.successRateLabel)
        self.contentView.addSubview(self.backgroundImageView)
        self.contentView.addSubview(self.shareButton)
        self.contentView.addSubview(self.shareButton)
    }
    
    private func layoutUI() {        
        self.titleDescriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(30)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalTo(self.nextImageView.snp.leading).offset(-10)
            make.top.equalTo(self.titleDescriptionLabel.snp.bottom).offset(10)
        }
        
        self.nextImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(self.titleLabel.snp.centerY)
            make.size.equalTo(24)
        }
        
        self.firstVerticalBorderView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(17)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(1)
        }
        
        self.secondVerticalBorderView.snp.makeConstraints { make in
            make.top.equalTo(self.successRateDescriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(1)
        }
        
        self.progressDurationDescriptionLabel.setContentHuggingPriority(.required, for: .horizontal)
        self.progressDurationDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.firstVerticalBorderView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(30)
        }
        
        self.progressDurationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.progressDurationDescriptionLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(30)
            make.leading.equalTo(self.progressDurationDescriptionLabel.snp.trailing).offset(10)
        }
        
        self.successRateDescriptionLabel.setContentHuggingPriority(.required, for: .horizontal)
        self.successRateDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.progressDurationDescriptionLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(30)
        }
        
        self.successRateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.successRateDescriptionLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(30)
            make.leading.equalTo(self.successRateDescriptionLabel.snp.trailing).offset(10)
        }
        
        self.backgroundImageView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(18)
        }
        
        self.shareButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(24)
            make.size.equalTo(45)
        }
    }
    
    private func bindUI() {
        self.shareButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                guard let presentable = owner.presentable else { return }
                owner.delegate?.myhabitCollectionViewCell(owner, didTapShare: presentable)
            })
            .disposed(by: self.disposeBag)
        
        self.contentView.addGestureRecognizer(self.makeTapGestureRecoginizer())
    }
    
    private func makeTapGestureRecoginizer() -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.rx.event
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.delegate?.myhabitCollectionViewCellDidTap(owner)
            })
            .disposed(by: self.disposeBag)
        return tapGestureRecognizer
    }
    
    private func updateLabelText(asPresentable presentable: MyHabitCellPresentable, index: Int) {
        guard let habitStatus = presentable.onethingHabitStatus                                    else { return }
        guard let userNickname = OnethingUserManager.sharedInstance.currentUser?.account?.nickname else { return }
        
        let isSuccess = habitStatus == .success
        let descriptionSuccessText = isSuccess ? "성공" : "실패"
        
        self.titleLabel.text = presentable.title
        self.titleDescriptionLabel.text = "\(userNickname) 님의 \(index + 1)번째 \(descriptionSuccessText) 습관"
        self.progressDurationLabel.text = presentable.progressDuration
        self.successRateLabel.text = "\(presentable.successPercent)%"
    }
    
    private func updateUI(asPresentable presentable: MyHabitCellPresentable) {
        self.contentView.backgroundColor = presentable.cellBackgroundColor
        self.backgroundImageView.image = presentable.cellBackgroundImage
        self.firstVerticalBorderView.backgroundColor = presentable.cellBorderViewColor
        self.secondVerticalBorderView.backgroundColor = presentable.cellBorderViewColor
    }
    
    private(set) var presentable: MyHabitCellPresentable?
    
    private let disposeBag = DisposeBag()
    
    private let titleDescriptionLabel = UILabel(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let nextImageView = UIImageView(frame: .zero)
    private let firstVerticalBorderView = UIView(frame: .zero)
    private let secondVerticalBorderView = UIView(frame: .zero)
    private let progressDurationDescriptionLabel = UILabel(frame: .zero)
    private let progressDurationLabel = UILabel(frame: .zero)
    private let successRateDescriptionLabel = UILabel(frame: .zero)
    private let successRateLabel = UILabel(frame: .zero)
    private let backgroundImageView = UIImageView(frame: .zero)
    private let shareButton = UIButton(frame: .zero)
    
}
