//
//  FAQViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/21.
//

import RxCocoa
import RxSwift
import UIKit

final class FAQViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.bindButtons()
        
        self.viewModel.requestFAQ()
    }
    
    private func setupTableView() {
        self.tableView.registerCell(cellType: FAQTableViewCell.self)
        self.tableView.rowHeight          = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 64
        self.viewModel.faqRelay.bind(to: self.tableView.rx.items) { [weak self] tableView, index, item in
            guard let self = self     else { return UITableViewCell() }
            guard let faqId = item.id else { return UITableViewCell() }
            
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.dequeueReuableCell(cell: FAQTableViewCell.self, forIndexPath: indexPath)
            let expanding = self.viewModel.expandingSet.contains(faqId)
            
            guard let faqCell = cell else { return UITableViewCell() }
            faqCell.configure(item)
            faqCell.updateLayoutForExpand(expanding, animated: false)
            
            return faqCell
        }.disposed(by: self.disposeBag)
    }
    
    private func bindButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel  = FAQViewModel()
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var backButton: UIButton!
    
}

extension FAQViewController: FAQTableViewCellDelegate {
    
    func faqTableViewCell(_ cell: FAQTableViewCell, isExpanding: Bool, didUpdateExpand notice: NoticeModel) {
        self.viewModel.updateExpandingStatus(of: notice, expanding: isExpanding)
    }
    
}
