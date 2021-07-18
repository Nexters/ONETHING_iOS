//
//  GoalProgressView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/18.
//

import UIKit

final class GoalProgressView: UIView {

    /// Progress를 나타낼 수 있는 Total Count
    /// - `totalProgress`를 조절하는 것으로 UI 업데이트가 가능
    var totalProgress: Int = 3 {
        didSet { self.updateProgress() }
    }
    
    /// 현재 단계를 나타내는 Progress
    /// - 1단계씩 늘어날 떄마다, `currentProgress` / `totalProgress`로 UI에 표시됩니다.
    /// - `currentProgress`를 조절하는 것으로 UI 업데이트가 가능
    var currentProgress: Int = 0 {
        didSet { self.updateProgress() }
    }
    
    var totalProgressColor: UIColor = .black_20
    var currentProgressColor: UIColor = .black_100
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupProgressView()
    }
    
    private func setupProgressView() {
        self.totalProgressView.backgroundColor = self.totalProgressColor
        self.currentProgressView.backgroundColor = self.currentProgressColor
    }
    
    private func updateProgress() {
        let progressRatio = CGFloat(self.currentProgress) / CGFloat(self.totalProgress)
        self.currentProgressWidthConstraint.constant = progressRatio * self.bounds.width
        self.layoutIfNeeded()
        
        self.currentProgressLabel.text = "\(self.currentProgress)"
    }
    
    @IBOutlet private weak var totalProgressView: UIView!
    @IBOutlet private weak var currentProgressView: UIView!
    @IBOutlet private weak var currentProgressLabel: UILabel!
    @IBOutlet private weak var currentProgressWidthConstraint: NSLayoutConstraint!
    
}
