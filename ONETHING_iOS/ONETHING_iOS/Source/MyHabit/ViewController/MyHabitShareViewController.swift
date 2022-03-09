//
//  HabitShareViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/05.
//

import RxCocoa
import RxSwift
import Then
import SnapKit
import UIKit

final class MyHabitShareViewController: BaseViewController {
    
    init(viewModel: MyHabitShareViewModel = MyHabitShareViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupLayout()
        self.bindUI()
        self.observeViewModel()
    }
    
    private func setupUI() {
        self.navigationView.do {
            $0.backgroundColor = .clear
            $0.delegate = self
        }
        
        self.shareContentView.do {
            $0.backgroundColor = .clear
        }
        
        self.buttonStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.spacing = 21
        }
        
        self.firstShareSelectButton.do {
            $0.setImage(HabitShareType.first.buttonImage, for: .normal)
        }
        
        self.secondShareSelectButton.do {
            $0.setImage(HabitShareType.second.buttonImage, for: .normal)
        }
        
        self.thirdShareSelectButton.do {
            $0.setImage(HabitShareType.third.buttonImage, for: .normal)
        }
        
        self.fourthShareSelectButton.do {
            $0.setImage(HabitShareType.fourth.buttonImage, for: .normal)
        }
        
        self.selectBoxImage.do {
            $0.image = UIImage(named: "select_box")
        }
        
        self.view.addSubview(self.navigationView)
        self.view.addSubview(self.shareContentView)
        self.view.addSubview(self.buttonStackView)
        self.buttonStackView.addArrangedSubview(self.firstShareSelectButton)
        self.buttonStackView.addArrangedSubview(self.secondShareSelectButton)
        self.buttonStackView.addArrangedSubview(self.thirdShareSelectButton)
        self.buttonStackView.addArrangedSubview(self.fourthShareSelectButton)
        self.view.addSubview(self.selectBoxImage)
    }
    
    private func setupLayout() {
        self.navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        self.shareContentView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(self.shareContentView.snp.width)
        }
        
        self.buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.shareContentView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        self.firstShareSelectButton.snp.makeConstraints { make in
            make.height.equalTo(self.firstShareSelectButton.snp.width)
        }
        
        self.secondShareSelectButton.snp.makeConstraints { make in
            make.height.equalTo(self.secondShareSelectButton.snp.width)
        }
        
        self.thirdShareSelectButton.snp.makeConstraints { make in
            make.height.equalTo(self.thirdShareSelectButton.snp.width)
        }
        
        self.fourthShareSelectButton.snp.makeConstraints { make in
            make.height.equalTo(self.fourthShareSelectButton.snp.width)
        }
    }
    
    private func bindUI() {
        self.firstShareSelectButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.viewModel.occur(viewEvent: .didTapShareButton(type: .first))
            })
            .disposed(by: self.disposeBag)
        
        self.secondShareSelectButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.viewModel.occur(viewEvent: .didTapShareButton(type: .second))
            })
            .disposed(by: self.disposeBag)
        
        self.thirdShareSelectButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.viewModel.occur(viewEvent: .didTapShareButton(type: .third))
            })
            .disposed(by: self.disposeBag)
        
        self.fourthShareSelectButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.viewModel.occur(viewEvent: .didTapShareButton(type: .fourth))
            })
            .disposed(by: self.disposeBag)
    }
    
    private func observeViewModel() {
        self.viewModel.selectShareTypeObservable
            .withUnretained(self)
            .subscribe(onNext: { owner, selectType in
                owner.shareContentView.updateShareType(selectType)
                owner.updateSelectBox(asShareType: selectType)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func updateSelectBox(asShareType type: HabitShareType) {
        switch type {
        case .first:
            self.selectBoxImage.snp.remakeConstraints { make in
                make.edges.equalTo(self.firstShareSelectButton.snp.edges)
            }
        case .second:
            self.selectBoxImage.snp.remakeConstraints { make in
                make.edges.equalTo(self.secondShareSelectButton.snp.edges)
            }
        case .third:
            self.selectBoxImage.snp.remakeConstraints { make in
                make.edges.equalTo(self.thirdShareSelectButton.snp.edges)
            }
        case .fourth:
            self.selectBoxImage.snp.remakeConstraints { make in
                make.edges.equalTo(self.fourthShareSelectButton.snp.edges)
            }
        }
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyHabitShareViewModel
    
    private let navigationView = MyHabitShareNavigationView(frame: .zero)
    private let shareContentView = MyHabitShareContentView(frame: .zero)
    private let buttonStackView = UIStackView()
    private let firstShareSelectButton = UIButton(frame: .zero)
    private let secondShareSelectButton = UIButton(frame: .zero)
    private let thirdShareSelectButton = UIButton(frame: .zero)
    private let fourthShareSelectButton = UIButton(frame: .zero)
    private let selectBoxImage = UIImageView(frame: .zero)

}

extension MyHabitShareViewController: MyHabitShareNavigationViewDelegate {
    
    func myHabitShareNavigationView(_ view: MyHabitShareNavigationView, didOccur event: MyHabitShareNavigationView.ViewEvent) {
        switch event {
        case .closeButton:
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
