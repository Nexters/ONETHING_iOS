//
//  GoalSettingFirstViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/12.
//

import RxSwift
import RxCocoa
import UIKit

final class GoalSettingFirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLoadingIndicatorView()
        self.setupLabels()
        self.setupCollectionView()
        self.setupDisplayLayer()
        self.bindButtons()
        self.observeViewModel()
        
        self.viewModel.requestRecommendedHabit()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.directSetButtonBottomConstraint.constant = 12 + DeviceInfo.safeAreaBottomInset
    }
    
    private func set() {
        
    }
    
    private func setupLabels() {
        guard let pretendard_medium = UIFont.createFont(type: .pretendard(weight: .medium), size: 26) else { return }
        guard let pretendard_bold = UIFont.createFont(type: .pretendard(weight: .bold), size: 26) else { return }
        
        guard let firstSubRange = "66일 동안".range(of: "66일") else { return }
        guard let thirdSubRange = "단 하나의 습관을".range(of: "단 하나의 습관") else { return }
        
        let mainAttribute: [NSAttributedString.Key: Any] = [.font: pretendard_medium,
                                                            .foregroundColor: UIColor.black_100]
        let subAttributes: [NSAttributedString.Key: Any] = [.font: pretendard_bold,
                                                            .foregroundColor: UIColor.black_100]
        
        let firstLineAttributeText = NSMutableAttributedString(string: "66일 동안", attributes: mainAttribute)
        firstLineAttributeText.addAttributes(subAttributes, range: firstSubRange)
        self.firstLineLabel.attributedText = firstLineAttributeText
        
        let thirdListAttributeText = NSMutableAttributedString(string: "단 하나의 습관을", attributes: mainAttribute)
        thirdListAttributeText.addAttributes(subAttributes, range: thirdSubRange)
        self.thirdLineLabel.attributedText = thirdListAttributeText
    }
    
    private func setupCollectionView() {
        self.collectionViews.forEach { collectionView in
            collectionView.registerCell(cellType: GoalSettingCollectionViewCell.self)
        }
        
        self.collectionViews.forEach { collectionView in
            collectionView.dataSource = self
            collectionView.delegate   = self
        }
    }
    
    private func setupDisplayLayer() {
        self.displayLayer = CADisplayLink(target: self, selector: #selector(self.updateContentOffset))
        self.displayLayer?.add(to: .main, forMode: .default)
    }
    
    private func setupLoadingIndicatorView() {
        self.view.addSubview(self.loadingIndicatorView)
        self.loadingIndicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        self.loadingIndicatorView.isHidden = true
        self.loadingIndicatorView.stopAnimating()
    }
    
    private func observeViewModel() {
        self.viewModel.reloadFlagSubejct.observeOnMain(onNext: { [weak self] in
            self?.collectionViews.forEach { $0.reloadData() }
            self?.collectionViews.forEach {
                guard let randomOffset = (0...300).randomElement() else { return }
                $0.contentOffset = CGPoint(x: randomOffset, y: 0)
            }
        }).disposed(by: self.disposeBag)
        
        self.viewModel.loadingSubject.observeOnMain(onNext: { [weak self] loading in
            if loading {
                self?.loadingIndicatorView.isHidden = false
                self?.loadingIndicatorView.startAnimating()
            } else {
                self?.loadingIndicatorView.isHidden = true
                self?.loadingIndicatorView.stopAnimating()
            }
        }).disposed(by: self.disposeBag)
    }
    
    private func bindButtons() {
        self.directSetButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.pushSecondGoalController()
        }).disposed(by: self.disposeBag)
    }
    
    private func pushSecondGoalController(_ habitName: String? = nil) {
        guard let viewController = GoalSettingSecondViewController
                .instantiateViewController(from: .goalSetting) else { return }
        if let habitName = habitName { viewController.setHabitName(habitName) }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func updateContentOffset() {
        self.collectionViews.forEach { collectionView in
            guard collectionView.contentSize.width != 0 else { return }
            
            let currentOffset = collectionView.contentOffset.x
            collectionView.contentOffset = CGPoint(x: currentOffset + 0.5, y: 0)
        }
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel  = GoalSettingFirstViewModel()
    
    private var displayLayer: CADisplayLink?

    private let loadingIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    @IBOutlet private weak var firstLineLabel: UILabel!
    @IBOutlet private weak var thirdLineLabel: UILabel!
    @IBOutlet private var collectionViews: [UICollectionView]!
    @IBOutlet private weak var directSetButton: UIButton!
    @IBOutlet private weak var directSetButtonBottomConstraint: NSLayoutConstraint!
    
}

extension GoalSettingFirstViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.viewModel.habbitSection.isEmpty == false else { return 0 }
        return 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let currentLine = self.collectionViews.firstIndex(where: { $0 == collectionView }) else { return UICollectionViewCell() }
        guard let recommendedHabbit
                = self.viewModel.habbitSection[safe: currentLine]?[safe: indexPath.row % GoalSettingFirstViewModel.lineHabitOffset] else {
            return UICollectionViewCell()
        }
        
        guard let goalSettingCell = collectionView.dequeueReusableCell(cell: GoalSettingCollectionViewCell.self, forIndexPath: indexPath) else {
            return UICollectionViewCell()
        }
        goalSettingCell.configure(recommendedHabbit)
        return goalSettingCell
    }
    
}

extension GoalSettingFirstViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentLine = self.collectionViews.firstIndex(where: { $0 == collectionView }) else { return }
        guard
            let recommendedHabbit = self.viewModel.habbitSection[safe: currentLine]?[safe: indexPath.row % GoalSettingFirstViewModel.lineHabitOffset] else {
            return
        }
        self.pushSecondGoalController(recommendedHabbit.title)
    }
    
}

extension GoalSettingFirstViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var currentLine: Int = 0
        for index in self.collectionViews.indices {
            if self.collectionViews[safe: index] == collectionView { currentLine = index; break }
        }
        
        guard
            let habbit = self.viewModel.habbitSection[safe: currentLine]?[safe: indexPath.row % GoalSettingFirstViewModel.lineHabitOffset] else {
            return .zero
        }
        let dummyLabel  = UILabel(frame: .zero)
        dummyLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        dummyLabel.text = habbit.title
        
        let edgeInset = UIEdgeInsets(top: 26, left: 41, bottom: 26, right: 41)
        let size      = dummyLabel.sizeThatFits(edgeInset)
        return CGSize(width: size.width, height: 74)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
