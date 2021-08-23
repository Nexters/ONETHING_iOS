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
    
    func configure(_ noticeModel: NoticeModel) {
        self.noticeTitleLabel.text = noticeModel.title
        self.noticeDescriptionLabel.text = noticeModel.content
        
        if let boldFont = UIFont.createFont(type: .pretendard(weight: .bold), size: 12),
           let attributeText = noticeModel.content?.attributeFontAsTag(startTag: "<b>", endTag: "</b>",
                                                                       attributes: [.font: boldFont,
                                                                                    .foregroundColor: UIColor.black_100]) {
            self.noticeDescriptionLabel.attributedText = attributeText
            return
        }
        
        if let createDate = noticeModel.createDateTime,
           let convertedDate = createDate.convertToDate(format: "yyyy-MM-dd'T'HH:mm:ss") {
            var convertedStringDate = convertedDate.convertString(format: "yyyy.MM.dd")
            convertedStringDate.removeFirst()
            convertedStringDate.removeFirst()
            self.dateLabel.text = convertedStringDate
        }
    }
    
    private func bindButtons() {
        self.expandButton.rx.tap.observeOnMain(onNext: { [weak self] in
            guard let self = self else { return }
            
            self.expanding.toggle()
            
            self.borderView.isHidden = self.expanding == true
            self.updateExpandUI(self.expanding)
            self.updateLayoutForExpand(self.expanding)
        }).disposed(by: self.disposeBag)
    }
    
    private func updateLayoutForExpand(_ expanding: Bool) {
        let constant: CGFloat = expanding ? self.noticeDescriptionLabel.frame.height + (20 * 2) : 0
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
    @IBOutlet private weak var borderView: UIView!
    
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
}
