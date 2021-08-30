//
//  AnnounceTableViewCell.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/21.
//

import RxSwift
import RxCocoa
import UIKit

protocol NoticeTableViewCellDelegate: AnyObject {
    func noticeTableViewCell(_ cell: NoticeTableViewCell, isExpanding: Bool, didUpdateExpand notice: NoticeModel)
}

class NoticeTableViewCell: UITableViewCell {
    
    weak var delegate: NoticeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bindTapGesture()
    }
    
    func configure(_ noticeModel: NoticeModel) {
        self.noticeModel = noticeModel
        
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
    
    func updateLayoutForExpand(_ expanding: Bool, animated: Bool = true) {
        let constant: CGFloat = expanding ? self.noticeDescriptionLabel.frame.height + (20 * 2) : 0
        self.bottomConstraint.constant = constant
        self.expanding = expanding
        
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
            guard let self = self                    else { return }
            guard let noticeModel = self.noticeModel else { return }
            guard let expanding = self.expanding     else { return }
            
            self.delegate?.noticeTableViewCell(self, isExpanding: !expanding, didUpdateExpand: noticeModel)
            self.updateLayoutForExpand(!expanding, animated: true)
        }).disposed(by: self.disposeBag)
        self.addGestureRecognizer(tapGesture)
    }
    
    private func updateExpandUI(_ expanding: Bool, animated: Bool = true) {
        self.borderView.isHidden = expanding == true
        
        let transform: CGAffineTransform = expanding ? CGAffineTransform(rotationAngle: .pi) : .identity
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.expandButton.transform = transform
            }
        } else {
            self.expandButton.transform = transform
        }
    }
    
    private var expanding: Bool?
    private var noticeModel: NoticeModel?
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var expandButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var noticeTitleLabel: UILabel!
    @IBOutlet private weak var noticeDescriptionLabel: UILabel!
    @IBOutlet private weak var noticeDescriptionView: UIView!
    @IBOutlet private weak var borderView: UIView!
    
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
}
