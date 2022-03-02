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

final class HabitManagingController: BaseViewController {
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    private let tableView = UITableView()
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    private let viewModel = HabitManagingViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.bindButtons()
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
            menuCell.configure(item.title)
            menuCell.selectionStyle = .none
            return menuCell
        }.disposed(by: self.disposeBag)
        
    }
    
    private func layoutTableView() {
        self.view.addSubview(self.tableView)
        self.tableView.backgroundColor = .red
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
}
