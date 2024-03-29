//
//  HabitModfiyViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/25.
//

import UIKit

import RxSwift
import RxCocoa

protocol HabitEditingViewControllerDelegate: AnyObject {
    func habitEditingViewControllerDidTapCompleteButton(_ habitEditingViewController: HabitEditingViewController)
}

final class HabitEditingViewController: BaseViewController {
    weak var delegate: HabitEditingViewControllerDelegate?
    
    private let delayTouchView = UIView()
    let viewModel: HabitEditViewModel
    
    init?(coder: NSCoder, viewModel: HabitEditViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTimeRelatedViews()
        self.setupDelayInfoViews()
        self.setupPenaltyInfoView()
        self.setupCountPicker()
        self.setupColorSelectButtons()
        self.setupDelayTouchView()
        self.updateViews(with: self.viewModel)
        
        self.bindingButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
    
    private func setupTimeRelatedViews() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.timeSetViewDidTap))
    
        self.timeSetView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func timeSetViewDidTap() {
        self.tabBarController?.showPreparePopupView()
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
        
        let defaultSelectIndex = self.viewModel.habitInProgressModel.penaltyCount - 1
        self.countPicker.selectRow(defaultSelectIndex, inComponent: 0, animated: false)
    }
    
    private var prevColorSelectButton: ColorSelectButton?
    private func setupColorSelectButtons() {
        let currentColorIndex: Int = self.viewModel.currentColorIndex
        let firstButton = self.colorSelectButtons.first(where: { $0.tag == currentColorIndex })
        firstButton?.checkView.isHidden = false
        self.prevColorSelectButton = firstButton
    }
    
    private func setupDelayTouchView() {
        self.delayTouchView.backgroundColor = .clear
        
        self.view.addSubview(self.delayTouchView)
        self.delayTouchView.snp.makeConstraints {
            $0.top.equalTo(self.delayImageView)
            $0.trailing.equalTo(self.delayImageView)
            $0.leading.equalTo(self.delayRemainedCountLabel)
            $0.bottom.equalTo(self.delayImageView)
        }
    }
    
    private func updateViews(with viewModel: HabitEditViewModel?) {
        guard let viewModel = viewModel else { return }
        
        self.timeStampLabel.text = viewModel.pushTimeText
        self.timeStampLabel.sizeToFit()
        self.delayInfoViews.forEach { delayInfoView in
            delayInfoView.image = viewModel.delayImage(at: delayInfoView.tag)
        }
        self.delayRemainedCountLabel.text = viewModel.delayRemainedText
        self.penaltyInfoView?.updateCount(with: viewModel)
        self.penaltyInfoView?.update(sentence: viewModel.penaltySentence)
        self.colorSelectButtons.forEach { button in
            button.backgroundColor = viewModel.color(at: button.tag)
        }
    }
    
    private func bindingButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        self.manageButton.rx.tap.observeOnMain(onNext: { [weak self] _ in
            guard let managingViewController = HabitManagingViewController.instantiateViewController(from: .habitEdit) else { return }
            
            managingViewController.viewModel.update(habitInProgressModel: self?.viewModel.habitInProgressModel)
            self?.navigationController?.pushViewController(managingViewController, animated: true)
        }).disposed(by: self.disposeBag)

        let tapGestureForDelayTouchView = UITapGestureRecognizer()
        self.delayTouchView.addGestureRecognizer(tapGestureForDelayTouchView)
        tapGestureForDelayTouchView.rx.event.observeOnMain(onNext: { [weak self] _ in
            guard let self = self else { return }
            let notifyView = DelayNotifyPopupView()
            notifyView.show(in: self.view)
        }).disposed(by: self.disposeBag)
        
        self.countPicker.rx.itemSelected.observeOnMain(onNext: { [weak self] row, _ in
            self?.viewModel.update(penaltyCount: row + 1)
            self?.updateViews(with: self?.viewModel)
        }).disposed(by: self.disposeBag)
        
        let tapGestureForHideCountPicker = UITapGestureRecognizer()
        tapGestureForHideCountPicker.rx.event.observeOnMain(onNext: { [weak self] _ in
            self?.view.endEditing(true)
            self?.hideCountPicker()
        }).disposed(by: self.disposeBag)
        self.view.addGestureRecognizer(tapGestureForHideCountPicker)
        
        self.pickerCompleteButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.view.endEditing(true)
            self?.hideCountPicker()
        }).disposed(by: self.disposeBag)
        
        self.colorSelectButtons.forEach { button in
            button.rx.tap.observeOnMain(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                button.checkView.isHidden = false
                self.prevColorSelectButton?.checkView.isHidden = true
                self.prevColorSelectButton = button
                self.viewModel.updateColor(with: button.tag)
            }).disposed(by: self.disposeBag)
        }
        
        self.completeButton.rx.tap.observeOnMain(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.completeButton.isUserInteractionEnabled = false
            self.viewModel.putEditHabit(completionHandler: { [weak self] _ in
                guard let self = self else { return }
                
                self.delegate?.habitEditingViewControllerDidTapCompleteButton(self)
                self.navigationController?.popViewController(animated: true)
            }, failureHandler: {
                self.completeButton.isUserInteractionEnabled = true
            })
            
        }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var manageButton: UIButton!
    
    @IBOutlet private weak var timeSetView: UIView!
    @IBOutlet private weak var timeStampLabel: UILabel!
    
    @IBOutlet private var delayInfoViews: [UIImageView]!
    @IBOutlet private weak var delayRemainedCountLabel: UILabel!
    @IBOutlet private weak var delayImageView: UIImageView!

    @IBOutlet private weak var penaltyInfoContainerView: UIView!
    private let penaltyInfoView: PenaltyInfoView? = UIView.createFromNib()
    
    @IBOutlet private var colorSelectButtons: [ColorSelectButton]!
    @IBOutlet private weak var completeButton: UIButton!
    @IBOutlet private weak var pickerCompleteButton: UIButton!
    
    @IBOutlet private weak var countPickerContainerView: UIView!
    @IBOutlet private weak var countPicker: UIPickerView!
    @IBOutlet private weak var countPickerBottomConstraint: NSLayoutConstraint!
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
