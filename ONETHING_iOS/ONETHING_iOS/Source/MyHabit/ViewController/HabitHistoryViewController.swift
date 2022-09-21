//
//  HabitHistoryViewController.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 12/09/2022.
//

import UIKit

final class HabitHistoryViewController: UIViewController {
    private let myHabitInfoView = MyHabitInfoView()
    private let viewModel: HabitHistoryViewModel
    
    var viewsAreHidden: Bool = false {
        didSet {
            self.myHabitInfoView.isHidden = self.viewsAreHidden
            self.view.backgroundColor = self.viewsAreHidden ? .clear : .white
        }
    }
    
    init(viewModel: HabitHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupLayout()
        self.myHabitInfoView.update(with: self.viewModel.habitInfoViewModel)
    }
    
    private func setupUI() {
        self.myHabitInfoView.do {
            $0.delegate = self
        }
        
        self.view.addSubview(self.myHabitInfoView)
    }
    
    private func setupLayout() {
        self.myHabitInfoView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
        })
    }
}

extension HabitHistoryViewController: MyHabitInfoViewDelegate {
    func myHabitInfoView(_ view: MyHabitInfoView, didOccur event: MyHabitInfoView.ViewEvent) {
        switch event {
        case .backButton:
            self.dismiss(animated: true)
        case .share:
            self.presentHabitShareViewController(selectedHabit: self.viewModel.presentable)
        }
    }
    
    private func presentHabitShareViewController(selectedHabit: MyHabitCellPresentable?) {
        guard let selectedHabit = selectedHabit else { return }
        
        let habitShareViewController = MyHabitShareViewController()
        habitShareViewController.setShareHabit(selectedHabit)
        habitShareViewController.modalPresentationStyle = .fullScreen
        self.present(habitShareViewController, animated: true, completion: nil)
    }

}

