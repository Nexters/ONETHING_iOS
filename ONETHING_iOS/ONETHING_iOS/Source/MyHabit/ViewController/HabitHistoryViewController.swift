//
//  HabitHistoryViewController.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 12/09/2022.
//

import UIKit

import RxSwift
import RxCocoa

protocol HabitHistoryViewControllerDelegate: AnyObject {
    func habitHistoryViewControllerDidDeleteHabit(_ habitHistoryViewController: HabitHistoryViewController, deletedHabitID: Int)
}

final class HabitHistoryViewController: UIViewController, HabitWrittentVCParentable {
    let backgroundDimView = BackgroundDimView()
    private let myHabitInfoView = MyHabitInfoView()
    private let habitTabBar = HabitTabBar()
    private let containerView = UIView()
    private lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageVC.view.frame = self.containerView.bounds
        pageVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageVC.didMove(toParent: self)
        pageVC.dataSource = self
        pageVC.delegate = self
        return pageVC
    }()
    private lazy var subViewControllers: [HabitHistorySubViewController] = {
        let subViewControllers: [HabitHistorySubViewController] = [
            HabitStampsViewController(viewModel: self.viewModel),
            HabitImagesViewController(viewModel: self.viewModel),
            HabitDocumentsViewController(viewModel: self.viewModel)
        ]
        
        subViewControllers.forEach {
            $0.delegate = self
        }
        
        return subViewControllers
    }()
    private var loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    
    let viewModel: HabitHistoryViewModel
    private let disposeBag = DisposeBag()
    weak var delegate: HabitHistoryViewControllerDelegate?
    
    var viewsAreHidden: Bool = false {
        didSet {
            self.myHabitInfoView.isHidden = self.viewsAreHidden
            self.view.backgroundColor = self.viewsAreHidden ? .clear : .white
            self.viewsAreHidden == true ? self.habitTabBar.isHidden = true : self.habitTabBar.showCrossDissolve()
            self.viewsAreHidden == true ? self.containerView.isHidden = true : self.containerView.showCrossDissolve()
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
        
        self.viewModel.fetchDailyHabits()
        self.changePage(to: 0)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.loadingIndicator.do {
            $0.stopAnimating()
        }
        
        self.myHabitInfoView.do {
            $0.delegate = self
        }
        
        self.habitTabBar.do {
            $0.delegate = self
        }
     
        self.view.addSubview(self.loadingIndicator)
        self.view.addSubview(self.myHabitInfoView)
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.pageViewController.view)
        self.view.addSubview(self.habitTabBar)
        self.view.addSubview(self.backgroundDimView)
    }
    
    private func setupLayout() {
        self.loadingIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        self.myHabitInfoView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
        })
        
        self.habitTabBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.myHabitInfoView.snp.bottom)
        }
        
        self.containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.habitTabBar.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
        self.backgroundDimView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func routeToHabitWrittenViewController(with dailyHabitModel: DailyHabitModel) {
        let habitWrittenViewController = HabitWrittenViewController().then {
            $0.viewModel = HabitWrittenViewModel(dailyHabitModel: dailyHabitModel)
        }
        
        let tapGestureForDimView = self.makeTapGestureRecognizerOfDimView(for: habitWrittenViewController)
        self.backgroundDimView.addTapGestureRecognizer(tapGestureForDimView)
        self.backgroundDimView.showCrossDissolve(completedAlpha: BackgroundDimView.completedAlpha)
        habitWrittenViewController.didMove(toViewController: self)
    }
    
    private func makeTapGestureRecognizerOfDimView(for habitWrittenViewController: HabitWrittenViewController) -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.rx.event
            .subscribe(onNext: { owner in
                habitWrittenViewController.removeFromParentVC()
            })
            .disposed(by: self.disposeBag)
        return tapGestureRecognizer
    }
}

extension HabitHistoryViewController: HabitHistorySubViewControllerDelegate {
    func didTapDailyHabit(_ viewController: HabitHistorySubViewController, dailyHabitModel: DailyHabitModel) {
        self.routeToHabitWrittenViewController(with: dailyHabitModel)
    }
}

extension HabitHistoryViewController: UIPageViewControllerDataSource {
    private func changePage(to nextIndexOfPage: Int, completion: ((Bool) -> Void)? = nil) {
        guard let destinationSubViewController = self.subViewControllers[safe: nextIndexOfPage]
        else { return }
        
        let currentIndexOfPage = self.currentIndexOfPage ?? 0
        DispatchQueue.main.async {
            self.pageViewController.setViewControllers(
                [destinationSubViewController],
                direction: (currentIndexOfPage < nextIndexOfPage) ? .forward : .reverse,
                animated: true,
                completion: completion
            )
        }
    }
    
    private var currentIndexOfPage: Int? {
        guard let currentVC = self.pageViewController.viewControllers?.first else { return nil }
        
        return self.subViewControllers.map({ subViewController -> UIViewController in
            return subViewController
        }).firstIndex(of: currentVC)
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        return nil
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        return nil
    }
}

extension HabitHistoryViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
    
    }
}

extension HabitHistoryViewController: HabitTabBarDelegate {
    func foo() {
        #warning("구현하자")
    }
}

extension HabitHistoryViewController: MyHabitInfoViewDelegate {
    func myHabitInfoView(_ view: MyHabitInfoView, didOccur event: MyHabitInfoView.ViewEvent) {
        switch event {
        case .backButton:
            self.dismiss(animated: true)
        case .share:
            self.presentHabitShareViewController(selectedHabit: self.viewModel.presentable)
        case .delete:
            self.showDeleteWarningPopupView()
        }
    }
    
    private func presentHabitShareViewController(selectedHabit: MyHabitCellPresentable?) {
        guard let selectedHabit = selectedHabit else { return }
        
        let habitShareViewController = MyHabitShareViewController()
        habitShareViewController.setShareHabit(selectedHabit)
        habitShareViewController.modalPresentationStyle = .fullScreen
        self.present(habitShareViewController, animated: true, completion: nil)
    }
    
    private func showDeleteWarningPopupView() {
        let popupView = self.deleteWarningPopupView
        popupView.show(in: self.view)
        self.view.bringSubviewToFront(self.loadingIndicator)
    }

    private var deleteWarningPopupView: TitleSubTitleConfirmPopupView {
        return TitleSubTitleConfirmPopupView().then { popupView in
            popupView.heightOfContentView = 160.0
            popupView.update(with: self.viewModel)
            popupView.confirmAction = { [weak self] _ in
                self?.viewModel.deleteHabit()
            }
            popupView.cancelAction = { popupView in
                popupView.removeFromSuperview()
            }
            self.observeViewModel(with: popupView)
        }
    }
    
    private func observeViewModel(with deleteWarningPopupView: TitleSubTitleConfirmPopupView) {
        self.viewModel.loadingSubject
            .subscribe(onNext: { [weak self, weak deleteWarningPopupView] loading in
                deleteWarningPopupView?.buttons.forEach {
                    $0.isUserInteractionEnabled = loading == false
                }
                loading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.completeSubject
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let deletedHabitID = self.viewModel.presentable?.habitId else { return }
                
                self.transitioningDelegate = nil
                self.delegate?.habitHistoryViewControllerDidDeleteHabit(self, deletedHabitID: deletedHabitID)
                self.dismiss(animated: true)
            }).disposed(by: self.disposeBag)
    }
}
