//
//  LoginViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/11.
//

import UIKit

final class LoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        let mainTitle = "66일 습관메이트\n뇽뇽에 어서오세요!"
        guard let mainFont = UIFont.createFont(type: .pretendard(weight: .bold), size: 26) else { return }
        guard let subFont = UIFont.createFont(type: .pretendard(weight: .regular), size: 26) else { return }
        guard let subRange = mainTitle.range(of: "에 어서오세요!") else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        
        let mainAttributes: [NSAttributedString.Key: Any] = [.font: mainFont, .foregroundColor: UIColor.white, .paragraphStyle: paragraphStyle]
        let subAttributes: [NSAttributedString.Key: Any] = [.font: subFont, .foregroundColor: UIColor.white]
        
        let attributeText = NSMutableAttributedString(string: mainTitle, attributes: mainAttributes)
        attributeText.addAttributes(subAttributes, range: subRange)
        
        self.titleLabel.attributedText = attributeText
    }
    
    private let viewModel = LoginViewModel()

    @IBOutlet private weak var titleLabel: UILabel!
    
}
