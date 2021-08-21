//
//  AnnounceTableViewCell.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/21.
//

import RxSwift
import RxCocoa
import UIKit

class NoticeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bindButtons()
    }
    
    private func bindButtons() {
        self.expandButton.rx.tap.observeOnMain(onNext: { [weak self] in
            guard let self = self else { return }
            
            self.expanding.toggle()
            
            self.updateExpandUI(self.expanding)
            self.updateLayoutForExpand(self.expanding)
        }).disposed(by: self.disposeBag)
    }
    
    private func updateLayoutForExpand(_ expanding: Bool) {
        let edge: UIEdgeInsets = UIEdgeInsets(top: 20, left: 32, bottom: 20, right: 32)
        let constant: CGFloat = expanding ? self.noticeDescriptionLabel.sizeThatFits(edge).height : 0
        self.bottomConstraint.constant = constant
        
        UIView.animate(withDuration: 0.3) { self.layoutIfNeeded() }
        
        (self.superview as? UITableView)?.beginUpdates()
        (self.superview as? UITableView)?.endUpdates()
    }
    
    private func updateExpandUI(_ expanding: Bool) {
        let transform: CGAffineTransform = expanding ? CGAffineTransform(rotationAngle: .pi) : .identity
        UIView.animate(withDuration: 0.3) {
            self.expandButton.transform = transform
        }
    }
    
    private var expanding: Bool = false
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var expandButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var noticeTitleLabel: UILabel!
    @IBOutlet private weak var noticeDescriptionLabel: UILabel!
    @IBOutlet private weak var noticeDescriptionView: UIView!
    
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
}
