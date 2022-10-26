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

extension HabitManagingViewController: FailPopupViewDelegate {
    func failPopupViewDidTapClose(_ failPopupView: FailPopupView) {
        self.viewModel.executeGiveUp()
    }
}

final class HabitManagingViewController: BaseViewController {
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    private let tableView = UITableView()
    private var tableViewHeightConstraint: NSLayoutConstraint!
    private var loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    var viewModel = HabitManagingViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLoadingIndicator()
        self.setupTableView()
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
    
    private func setupLoadingIndicator() {
        self.view.addSubview(self.loadingIndicator)
        self.loadingIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        self.loadingIndicator.stopAnimating()
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
                self.showGiveUpWarningView()
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func showStartAgainView() {
        let popupView = self.startAgainPopupView
        popupView.show(in: self.view)
        self.view.bringSubviewToFront(self.loadingIndicator)
    }
    
    private var startAgainPopupView: TitleSubTitleConfirmPopupView {
        return TitleSubTitleConfirmPopupView().then {
            $0.heightOfContentView = 184.0
            $0.update(with: self.viewModel)
            self.observeViewModel(with: $0)
            $0.confirmAction = { [weak self] _ in
                self?.viewModel.executeReStart()
            }
            $0.cancelAction = { popupView in
                popupView.removeFromSuperview()
            }
        }
    }
    
    private func showGiveUpWarningView() {
        let popupView = GiveUpWarningPopupView().then {
            $0.update(with: self.viewModel)
            $0.confirmAction = { [weak self] popupView in
                self?.showFailPopupView()
                popupView.isHidden = true
            }
            $0.cancelAction = { popupView in
                popupView.removeFromSuperview()
            }
        }
        popupView.show(in: self.view)
    }
    
    private func showFailPopupView() {
        guard let failPopupView: FailPopupView = UIView.createFromNib() else { return }
        
        failPopupView.delegate = self
        failPopupView.configure(with: self.viewModel, reason: .giveup)
        self.observeViewModel(with: failPopupView)
        failPopupView.show(in: self) { [weak self] in
            guard let self = self else { return }
            
            failPopupView.animateShaking()
            self.view.bringSubviewToFront(self.loadingIndicator)
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
    
    private func observeViewModel(with popupView: TitleSubTitleConfirmPopupView) {
        self.viewModel.loadingSubject
            .subscribe(onNext: { [weak self, weak popupView] loading in
                popupView?.buttons.forEach {
                    $0.isUserInteractionEnabled = loading == false
                }
                loading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.completeSubject
            .subscribe(onNext: { [weak self] in
                guard let homeViewController = self?.navigationController?
                        .rootViewController(type: HomeViewController.self)
                else { return }
                
                homeViewController.viewModel.requestHabitInProgress()
                self?.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: self.disposeBag)
    }
    
    private func observeViewModel(with popupView: FailPopupView) {
        self.viewModel.loadingSubject
            .subscribe(onNext: { [weak self, weak popupView] loading in
                popupView?.closeButton.isUserInteractionEnabled = loading == false
                loading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.completeSubject
            .subscribe(onNext: { [weak self] in
                guard let homeViewController = self?.navigationController?
                        .rootViewController(type: HomeViewController.self)
                else { return }
                
                homeViewController.mainTabBarController?.broadCastRequiredReload()
                homeViewController.viewModel.requestHabitInProgress()
                self?.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: self.disposeBag)
    }
}
