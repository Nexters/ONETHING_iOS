//
//  FQATableViewCell.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/21.
//

import RxCocoa
import RxSwift
import UIKit

protocol FAQTableViewCellDelegate: AnyObject {
    func faqTableViewCell(_ cell: FAQTableViewCell, isExpanding: Bool, didUpdateExpand notice: NoticeModel)
}

class FAQTableViewCell: UITableViewCell {
    
    weak var delegate: FAQTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bindTapGesture()
        self.faqDescriptionLabel.text = "습관이 만들어지기까지 평균 66일이 걸린다.\n66일의 충분한 시간을 투자해 습관 하나를 일상으로 만들어라."
        self.faqDescriptionLabel.sizeToFit()
    }
    
    func configure(_ faqModel: NoticeModel) {
        self.faqModel           = faqModel
        self.faqTitleLabel.text = faqModel.title
        
        guard let boldFont = UIFont.createFont(type: .pretendard(weight: .bold), size: 12) else { return }
        guard let attributeText = faqModel.content?.attributeFontAsTag(startTag: "<b>", endTag: "</b>",
                                                                       attributes: [.font: boldFont,
                                                                                    .foregroundColor: UIColor.black_100]) else {
            return
        }
        self.faqDescriptionLabel.attributedText = attributeText
    }
    
    func updateLayoutForExpand(_ expanding: Bool, animated: Bool = true) {
        self.expanding = expanding
        
        let constant: CGFloat = expanding ? self.faqDescriptionLabel.frame.height + (20 * 2) : 0
        
        self.bottomConstraint.constant = constant
        
        if animated {
            UIView.animate(withDuration: 0.3) { self.layoutIfNeeded() }
        } else {
            self.layoutIfNeeded()
        }
        
        (self.superview as? UITableView)?.beginUpdates()
        (self.superview as? UITableView)?.endUpdates()
        
        self.updateExpandUI(expanding, animated: animated)
    }
    
    private func bindTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.observeOnMain(onNext: { [weak self] _ in
            guard let self = self                else { return }
            guard let expanding = self.expanding else { return }
            guard let faqModel = self.faqModel   else { return }
            
            self.delegate?.faqTableViewCell(self, isExpanding: !expanding, didUpdateExpand: faqModel)
            self.updateLayoutForExpand(!expanding, animated: true)
        }).disposed(by: self.disposeBag)
        self.addGestureRecognizer(tapGesture)
    }
    
    private func updateExpandUI(_ expanding: Bool, animated: Bool = true) {
        let transform: CGAffineTransform = expanding ? CGAffineTransform(rotationAngle: .pi) : .identity
        
        if animated {
            UIView.animate(withDuration: 0.3) { self.expandButton.transform = transform }
        } else {
            self.expandButton.transform = transform
        }
        self.borderView.isHidden = expanding
    }
    
    private var faqModel: NoticeModel?
    private var expanding: Bool?
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var expandButton: UIButton!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var faqTitleLabel: UILabel!
    @IBOutlet private weak var faqDescriptionLabel: UILabel!
    @IBOutlet private weak var borderView: UIView!
    
}
