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
    }
    
    private func setupTableView() {
        self.tableView.registerCell(cellType: NoticeTableViewCell.self)
        
        self.tableView.rowHeight          = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 82
        
        self.viewModel.noticesRelay.bind(to: self.tableView.rx.items) { tableView, index, item in
            let indexPath = IndexPath(row: index, section: 0)
            let cell      = tableView.dequeueReuableCell(cell: NoticeTableViewCell.self, forIndexPath: indexPath)
            
            guard let noticeCell = cell else { return UITableViewCell() }
            return noticeCell
        }.disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel  = NoticeViewModel()
    
    @IBOutlet private weak var tableView: UITableView!
    
}
