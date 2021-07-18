//
//  PostponeTodoView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/19.
//

import RxCocoa
import RxSwift
import UIKit

protocol PostponeTodoViewDelegate: AnyObject {
    func postponeTodoView(_ postponeTodoView: PostponeTodoView, didEditedText text: String)
    func postponeTodoViewDidTapCount(_ postponeTodoView: PostponeTodoView)
}

class PostponeTodoView: UIView {
    
    weak var delegate: PostponeTodoViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTextField()
        self.bindTextField()
        self.bindTapGesture()
    }
    
    func updateCount(_ count: Int) {
        self.countLabel.text = "\(count)번"
        self.countLabel.sizeToFit()
    }
    
    private func setupTextField() {
        guard let pretendardFont = UIFont(name: FontName.pretendard_semibold, size: 20) else { return }
        
        let attributePlaceHolderText = NSAttributedString(string: "매일 스쿼트 한 세트하기",
                                                          attributes: [.font: pretendardFont,
                                                                       .foregroundColor: UIColor.black_20])
        self.postponeTextfield.attributedPlaceholder = attributePlaceHolderText
    }
    
    private func bindTextField() {
        self.postponeTextfield.rx.text.orEmpty.observeOnMain(onNext: { [weak self] text in
            guard let self = self else { return }
            guard text.count <= type(of: self).maxInputCount else {
                self.postponeTextfield.text?.removeLast()
                return
            }
            
            self.postponeTextCountLabel.text = "\(text.count) / \(type(of: self).maxInputCount)"
            self.delegate?.postponeTodoView(self, didEditedText: text)
        }).disposed(by: self.disposeBag)
    }
    
    private func bindTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.postponeTodoViewDidTapCount(self)
        }).disposed(by: self.disposeBag)
        self.countView.addGestureRecognizer(tapGesture)
    }
    
    private static let maxInputCount: Int = 30
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var postponeTextfield: UITextField!
    @IBOutlet private weak var postponeTextCountLabel: UILabel!
    @IBOutlet private weak var countView: UIView!
    @IBOutlet private weak var countLabel: UILabel!
    
}
