//
//  HabitModfiyViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/25.
//

import UIKit

import RxSwift
import RxCocoa

final class HabitEditingViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTimeSetView()
        self.setupDelayInfoViews()
        self.setupPenaltyInfoView()
        self.setupCountPicker()
        self.setupColorSelectButtons()
        
        self.bindingButtons()
    }
    
    override func viewDidLayoutSubviews() {
        self.countPickerBottomConstraint.constant = 45 + DeviceInfo.safeAreaBottomInset
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupTimeSetView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.timeSetViewDidTap))
        
        self.timeSetView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func timeSetViewDidTap() {
        self.showPreparePopupView()
    }
    
    private func showPreparePopupView() {
        guard let preparePopupView: PreparePopupView = UIView.createFromNib() else { return }
        guard let tabbarController = self.tabBarController                    else { return }
        preparePopupView.show(in: tabbarController)
    }
    
    private func setupDelayInfoViews() {
        self.delayInfoViews.forEach {
            $0.image = UIImage(named: "delay_info")
        }
    }
    
    private func setupPenaltyInfoView() {
        guard let penaltyInfoView = self.penaltyInfoView else { return }
        
        self.penaltyInfoContainerView.addSubview(penaltyInfoView)
        penaltyInfoView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let countBoxTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.countBoxDidTap))
        penaltyInfoView.countBoxView.addGestureRecognizer(countBoxTapGesture)
    }
    
    @objc private func countBoxDidTap() {
        self.showCountPicker()
    }
    
    private func showCountPicker() {
        self.countPickerContainerView.isHidden = false
        self.countPickerContainerView.transform = CGAffineTransform(translationX: 0, y: 400)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1) {
            self.countPickerContainerView.transform = .identity
        }
    }
    
    private func hideCountPicker() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, animations: {
            self.countPickerContainerView.transform = CGAffineTransform(translationX: 0, y: 400)
        }, completion: { [weak self] _ in
            self?.countPickerContainerView.isHidden = true
        })
    }
    
    private func setupCountPicker() {
        self.countPicker.setValue(UIColor.white, forKey: "backgroundColor")
        self.countPicker.dataSource = self
        self.countPicker.delegate = self

    }
    
    private var prevColorSelectButton: ColorSelectButton?
    private func setupColorSelectButtons() {
        self.colorSelectButtons.forEach { button in
            if button.tag == 0 {
                button.checkView.isHidden = false
                self.prevColorSelectButton = button
            }
            
            button.rx.tap.observeOnMain(onNext: { _ in
                button.checkView.isHidden = false
                self.prevColorSelectButton?.checkView.isHidden = true
                self.prevColorSelectButton = button
            }).disposed(by: self.disposeBag)
        }
    }
    
    private func bindingButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { _ in
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        self.completeButton.rx.tap.observeOnMain(onNext: { _ in
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.observeOnMain(onNext: { [weak self] _ in
            self?.view.endEditing(true)
            self?.hideCountPicker()
        }).disposed(by: self.disposeBag)
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet weak var timeSetView: UIView!
    
    @IBOutlet var delayInfoViews: [UIImageView]!
    
    @IBOutlet private weak var penaltyInfoContainerView: UIView!
    private let penaltyInfoView: PenaltyInfoView? = UIView.createFromNib()
    
    @IBOutlet var colorSelectButtons: [ColorSelectButton]!

    @IBOutlet private weak var completeButton: UIButton!
    
    @IBOutlet weak var countPickerContainerView: UIView!
    @IBOutlet weak var countPicker: UIPickerView!
    @IBOutlet weak var countPickerBottomConstraint: NSLayoutConstraint!
}

extension HabitEditingViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
}

extension HabitEditingViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
}
