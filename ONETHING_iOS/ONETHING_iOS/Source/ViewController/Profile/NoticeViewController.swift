//
//  AnnounceViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/21.
//

import RxCocoa
import RxSwift
import UIKit

final class NoticeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.bindButtons()
        
        self.viewModel.requestNoticeModel()
    }
    
    private func setupTableView() {
        self.tableView.registerCell(cellType: NoticeTableViewCell.self)
        
        self.tableView.rowHeight          = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 82
        
        self.viewModel.noticesRelay.bind(to: self.tableView.rx.items) { [weak self] tableView, index, item in
            guard let self = self        else { return UITableViewCell() }
            guard let noticeId = item.id else { return UITableViewCell() }
            
            let indexPath = IndexPath(row: index, section: 0)
            let cell      = tableView.dequeueReuableCell(cell: NoticeTableViewCell.self, forIndexPath: indexPath)
            let isExpand  = self.viewModel.expandingSet.contains(noticeId)
            
            guard let noticeCell = cell  else { return UITableViewCell() }
            noticeCell.delegate = self
            noticeCell.configure(item)
            noticeCell.updateLayoutForExpand(isExpand, animated: false)
            
            return noticeCell
        }.disposed(by: self.disposeBag)
    }
    
    private func bindButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = NoticeViewModel()
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
}

extension NoticeViewController: NoticeTableViewCellDelegate {
    
    func noticeTableViewCell(_ cell: NoticeTableViewCell, isExpanding: Bool, didUpdateExpand notice: NoticeModel) {
        self.viewModel.updateExpandingStatus(of: notice, isExpanding: isExpanding)
    }
    
}
