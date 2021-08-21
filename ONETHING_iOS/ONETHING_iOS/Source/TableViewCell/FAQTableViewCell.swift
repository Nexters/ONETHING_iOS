//
//  FQATableViewCell.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/21.
//

import RxCocoa
import RxSwift
import UIKit

class FAQTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bindButtons()
        self.faqDescriptionLabel.text = "습관이 만들어지기까지 평균 66일이 걸린다.\n66일의 충분한 시간을 투자해 습관 하나를 일상으로 만들어라."
        self.faqDescriptionLabel.sizeToFit()
    }
    
    private func bindButtons() {
        self.expandButton.rx.tap.observeOnMain(onNext: { [weak self] in
            guard let self = self else { return }
            
            self.expanding.toggle()
            
            self.borderView.isHidden = self.expanding == true
            self.updateLayoutForExpand(self.expanding)
            self.updateExpandUI(self.expanding)
        }).disposed(by: self.disposeBag)
    }
    
    private func updateLayoutForExpand(_ expanding: Bool) {
        let constant: CGFloat = expanding ? self.faqDescriptionLabel.frame.height + (20 * 2) : 0
        
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
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var faqTitleLabel: UILabel!
    @IBOutlet private weak var faqDescriptionLabel: UILabel!
    @IBOutlet private weak var borderView: UIView!
    
}
