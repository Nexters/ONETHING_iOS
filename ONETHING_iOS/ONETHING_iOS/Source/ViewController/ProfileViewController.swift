//
//  ProfileViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import RxSwift
import RxCocoa
import UIKit

final class ProfileViewController: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    private func setupTableView() {
        let rowHeight: CGFloat = 64
        self.tableView.registerCell(cellType: ProfileMenuTableViewCell.self)
        self.tableView.rowHeight = rowHeight
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        self.tableViewHeightConstraint.constant = CGFloat(self.viewModel.menuRelay.value.count) * rowHeight
        
        self.viewModel.menuRelay.bind(to: self.tableView.rx.items) { tableView, index, item in
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.dequeueReuableCell(cell: ProfileMenuTableViewCell.self, forIndexPath: indexPath)
            
            guard let menuCell = cell else { return UITableViewCell() }
            menuCell.configure(item.title)
            if index == self.viewModel.menuRelay.value.count - 1 {
                menuCell.separatorInset = UIEdgeInsets(top: 0, left: DeviceInfo.screenWidth, bottom: 0, right: 0)
            }
            menuCell.selectionStyle = .none
            return menuCell
        }.disposed(by: self.disposeBag)
        
        self.tableView.rx.itemSelected.observeOnMain(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            guard let menu = ProfileViewModel.Menu(rawValue: indexPath.row) else { return }
            switch menu {
            case .myAccount:
                print("My Account")
            case .pushSetting:
                self.showPreparePopupView()
            case .fontSetting:
                self.showPreparePopupView()
            case .announce:
                self.showPreparePopupView()
            case .question:
                self.showPreparePopupView()
            }
        }).disposed(by: self.disposeBag)
    }
    
    private func showPreparePopupView() {
        guard let preparePopupView: PreparePopupView = UIView.createFromNib() else { return }
        preparePopupView.show(in: self)
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = ProfileViewModel()
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileEditButton: UIButton!
    
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var successCountLabel: UILabel!
    @IBOutlet private weak var postponeCountLabel: UILabel!
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    
}
