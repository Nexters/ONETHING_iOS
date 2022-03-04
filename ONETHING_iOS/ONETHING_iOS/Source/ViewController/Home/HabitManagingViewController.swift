//
//  HabitManageController.swift
//  ONETHING_iOS
//
//  Created by kimdo2297 on 2022/03/02.
//

import UIKit

import RxCocoa
import RxSwift
import Then

final class HabitManagingViewController: BaseViewController {
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    private let tableView = UITableView()
    private var tableViewHeightConstraint: NSLayoutConstraint!
    private let backgroundDimView = BackgroundDimView()
    private var loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    var viewModel = HabitManagingViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLoadingIndicator()
        self.setupTableView()
        self.setupBackgounndDimColorView()
        self.bindButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupBackgounndDimColorView() {
        self.view.addSubview(self.backgroundDimView)
        self.backgroundDimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupLoadingIndicator() {
        self.view.addSubview(self.loadingIndicator)
        self.loadingIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        self.loadingIndicator.hideAndStop()
    }
    
    private func setupTableView() {
        self.layoutTableView()
        self.tableView.do { tableView in
            let rowHeight: CGFloat = 64.0
            tableView.registerCell(cellType: MenuTableViewCell.self)
            tableView.rowHeight = rowHeight
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 32.0, bottom: 0, right: 32.0)
            self.tableViewHeightConstraint.constant = CGFloat(self.viewModel.menuRelay.value.count) * rowHeight
        }
        
        self.viewModel.menuRelay.bind(to: self.tableView.rx.items) { tableView, index, item in
            let indexPath = IndexPath(row: index, section: 0)
            let cell: MenuTableViewCell? = tableView.dequeueReuableCell(cell: MenuTableViewCell.self, forIndexPath: indexPath)
            
            guard let menuCell = cell else { return UITableViewCell() }
            menuCell.do {
                $0.configure(item.title)
                $0.selectionStyle = .none
                $0.titleLabel.textColor = .black_100
                $0.titleLabel.font = UIFont(name: FontType.pretendard(weight: .regular).fontName, size: 16)
            }
            return menuCell
        }.disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(HabitManagingViewModel.Menu.self).observeOnMain { [weak self] menu in
            guard let self = self else { return }
            switch menu {
            case .startAgain:
                self.showStartAgainView()
            case .giveup:
                #warning("알랏 띄우고 네 누르면 실패 뷰 띄우고 닫기 버튼 누르기. 닫기 누르면 서버에 습관 포기하기 api 쏘고, response 받고 홈으로 이동. 배경 딤처리&애니메이션 적용")
                #warning("loading indicator 적용하자")
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func showStartAgainView() {
        self.backgroundDimView.showCrossDissolve(completedAlpha: self.backgroundDimView.completedAlpha)
        let popupView = self.startAgainPopupView
        self.view.addSubview(popupView)
        popupView.snp.makeConstraints({
            $0.centerX.centerY.equalToSuperview()
        })
        self.view.bringSubviewToFront(self.loadingIndicator)
    }
    
    private var startAgainPopupView: StartAgainPopupView {
        return StartAgainPopupView().then {
            $0.update(with: self.viewModel)
            self.observeViewModel(with: $0)
            $0.confirmAction = { [weak self] _ in
                self?.viewModel.executeReStart()
            }
            $0.cancelAction = { [weak self] popupView in
                self?.backgroundDimView.hideCrossDissolve()
                popupView.removeFromSuperview()
            }
        }
    }
    
    private func layoutTableView() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints({
            let safeArea = self.view.safeAreaLayoutGuide
            $0.leading.trailing.equalTo(safeArea)
            $0.top.equalTo(self.headerView.snp.bottom)
        })
        
        let heightConstraint = NSLayoutConstraint(
            item: self.tableView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 100.0)
        self.tableViewHeightConstraint = heightConstraint
        heightConstraint.isActive = true
    }
    
    private func bindButtons() {
        self.backButton.rx.tap.observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
    }
    
    private func observeViewModel(with popupView: StartAgainPopupView) {
        self.viewModel.loadingSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, loading in
                popupView.buttons.forEach {
                    $0.isUserInteractionEnabled = loading == false
                }
                loading ? owner.loadingIndicator.showAndStart() : owner.loadingIndicator.hideAndStop()
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.completeSubject
            .withUnretained(self)
            .subscribe(onNext: { owner in
                guard let homeViewController = self.navigationController?
                        .rootViewController(type: HomeViewController.self)
                else { return }
                
                homeViewController.viewModel.requestHabitInProgress()
                self.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: self.disposeBag)
    }
}
