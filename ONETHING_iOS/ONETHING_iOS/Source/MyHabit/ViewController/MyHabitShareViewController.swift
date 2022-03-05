//
//  HabitShareViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/05.
//

import Then
import SnapKit
import UIKit

final class MyHabitShareViewController: BaseViewController {
    
    init(viewModel: MyHabitShareViewModel = MyHabitShareViewModel()) {
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
    }
    
    private func setupUI() {
        self.setupNavigationView()
    }
    
    private func setupLayout() {
        self.layoutNavigationView()
    }
    
    private func setupNavigationView() {
        self.navigationView.do {
            $0.backgroundColor = .clear
            $0.delegate = self
        }
        
        self.view.addSubview(self.navigationView)
    }
    
    private func layoutNavigationView() {
        self.navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    private let viewModel: MyHabitShareViewModel
    
    private let navigationView = MyHabitShareNavigationView(frame: .zero)

}

extension MyHabitShareViewController: MyHabitShareNavigationViewDelegate {
    
    func myHabitShareNavigationView(_ view: MyHabitShareNavigationView, didOccur event: MyHabitShareNavigationView.ViewEvent) {
        switch event {
        case .closeButton:
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
