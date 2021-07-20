//
//  HabitWritingViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import UIKit

final class HabitWritingViewController: BaseViewController {
    private var backBtnTitleView: BackBtnTitleView!
    private var completeButton: CompleteButton!
    private let dailyHabitInfoView = DailyHabitView()
    private let viewModel = HabitWritingViewModel()
    private let keyboardDismissableView = UIView()
    private let habitSelectStampView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.addKeyboardDismissTapGesture()
        self.setupKeyboardDismissableView()
        self.setupBackBtnTitleView()
        self.setupDailyHabitView()
        self.setupCompleteButton()
        self.setupHabitSelectStampView()
        self.view.bringSubviewToFront(self.dailyHabitInfoView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupKeyboardDismissableView() {
        self.keyboardDismissableView.backgroundColor = .red
        self.view.addSubview(self.keyboardDismissableView)
        
        self.keyboardDismissableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupBackBtnTitleView() {
        self.backBtnTitleView = BackBtnTitleView(parentViewController: self)
        self.backBtnTitleView.update(title: "1일차")
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.keyboardDismissableView.addSubview(self.backBtnTitleView)
        self.backBtnTitleView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(54)
            $0.leading.equalToSuperview().offset(32)
            $0.height.equalTo(self.backBtnTitleView.backButtonDiameter)
        }
    }
    
    private func setupDailyHabitView() {
        self.keyboardDismissableView.addSubview(self.dailyHabitInfoView)
        self.dailyHabitInfoView.snp.makeConstraints {
            $0.top.equalTo(self.backBtnTitleView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func setupCompleteButton() {
        self.completeButton = CompleteButton(parentViewController: self)
        
        self.view.addSubview(self.completeButton)
        let safeArea = self.view.safeAreaLayoutGuide
        self.completeButton.snp.makeConstraints {
            $0.leading.trailing.bottom.width.equalTo(safeArea)
            $0.height.equalTo(83)
        }
    }
    
    private func setupHabitSelectStampView() {
        self.habitSelectStampView.backgroundColor = .clear
        self.habitSelectStampView.delegate = self
        self.habitSelectStampView.dataSource = viewModel
        self.habitSelectStampView.registerCell(cellType: HabitCalendarCell.self)
        
        self.view.addSubview(self.habitSelectStampView)
        self.habitSelectStampView.snp.makeConstraints {
            $0.top.equalTo(self.dailyHabitInfoView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.bottom.equalTo(self.completeButton.snp.top)
        }
    }
    
    override func addKeyboardDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.keyboardDismissableView.addGestureRecognizer(tapGesture)
    }
}

extension HabitWritingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 46, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .blue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
