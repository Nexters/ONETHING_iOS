//
//  ProfileViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import Carte
import RxSwift
import RxCocoa
import UIKit

final class ProfileViewController: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObserver()
        self.setupTableView()
        self.bindButtons()
        self.observeViewModel()
        
        self.viewModel.requestUserInform()
        self.viewModel.requestHabits()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func reloadContentsIfRequired() {
        super.reloadContentsIfRequired()
    }
    
    private func addObserver() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(self.didUpdateUserInform(_:)), name: .didUpdateUserInform, object: nil)
    }
    
    private func setupTableView() {
        let rowHeight: CGFloat = 64
        self.tableView.registerCell(cellType: ProfileMenuTableViewCell.self)
        self.tableView.rowHeight = rowHeight
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        self.tableViewHeightConstraint.constant = CGFloat(self.viewModel.menuRelay.value.count) * rowHeight
        
        self.viewModel.menuRelay.bind(to: self.tableView.rx.items) { tableView, index, item in
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.dequeueReuableCell(cell: ProfileMenuTableViewCell.self, forIndexPath: indexPath)
            
            guard let menuCell = cell else { return UITableViewCell() }
            menuCell.configure(item.title)
            if index == self.viewModel.menuRelay.value.count - 1 {
                menuCell.separatorInset = UIEdgeInsets(top: 0, left: DeviceInfo.screenWidth, bottom: 0, right: 0)
            }
            menuCell.selectionStyle = .none
            return menuCell
        }.disposed(by: self.disposeBag)
        
        self.tableView.rx.itemSelected.observeOnMain(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            guard let menu = ProfileViewModel.Menu(rawValue: indexPath.row) else { return }
            switch menu {
            case .myAccount:
                self.pushAccountViewController()
            case .notice:
                self.pushNoticeViewController()
            case .question:
                self.pushFAQViewController()
            case .makePeople:
                self.pushMakePeopleViewController()
            case .openSource:
                self.pushOpenSourceLisenceView()
            }
        }).disposed(by: self.disposeBag)
    }
    
    private func bindButtons() {
        self.profileEditButton.rx.tap.observeOnMain(onNext: { [weak self] in
            let viewController = ProfileEditViewController.instantiateViewController(from: .profile)
            guard let profileEditController = viewController else { return }
            profileEditController.modalPresentationStyle = .fullScreen
            self?.present(profileEditController, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }
    
    private func observeViewModel() {
        self.viewModel.userRelay.observeOnMain(onNext: { [weak self] user in
            guard let self = self else { return }
            guard let user = user else { return }
            
            self.profileImageView.image = user.profileImageType?.image
            self.nicknameLabel.text = String(format: "%@ 님", user.nickname ?? "")
        }).disposed(by: self.disposeBag)
        
        Observable.combineLatest(self.viewModel.successCountRelay, self.viewModel.delayCountRelay)
            .observeOnMain(onNext: { [weak self] successCount, delayCount in
                self?.successCountLabel.text = "\(successCount)"
                self?.delayCountLabel.text = "\(delayCount)"
            }).disposed(by: self.disposeBag)
    }
    
    private func pushAccountViewController() {
        let viewController = AccountViewController.instantiateViewController(from: .profile)
        guard let accountViewController = viewController else { return }
        self.navigationController?.pushViewController(accountViewController, animated: true)
    }
    
    private func pushNoticeViewController() {
        let viewController = NoticeViewController.instantiateViewController(from: .profile)
        guard let noticeViewControlelr = viewController else { return }
        self.navigationController?.pushViewController(noticeViewControlelr, animated: true)
    }
    
    private func pushFAQViewController() {
        let viewController = FAQViewController.instantiateViewController(from: .profile)
        guard let faqViewController = viewController else { return }
        self.navigationController?.pushViewController(faqViewController, animated: true)
    }
    
    private func pushMakePeopleViewController() {
        let viewController = MakePeopleViewController.instantiateViewController(from: .profile)
        guard let makePeopleViewController = viewController else { return }
        self.navigationController?.pushViewController(makePeopleViewController, animated: true)
    }
    
    private func pushOpenSourceLisenceView() {
        let lisenceViewController = CarteViewController()
        let lisenceItems = CarteViewController.makeOpenSourceLisenceItems()
        lisenceViewController.items.append(contentsOf: lisenceItems)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(lisenceViewController, animated: true)
    }
    
    @objc private func didUpdateUserInform(_ notification: Notification) {
        guard let user = OnethingUserManager.sharedInstance.currentUser else { return }
        self.nicknameLabel.text = user.account?.nickname
        self.profileImageView.image = user.account?.profileImageType?.image
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = ProfileViewModel()
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileEditButton: UIButton!
    
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var successCountLabel: UILabel!
    @IBOutlet private weak var delayCountLabel: UILabel!
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    
}

extension CarteViewController {
    
    static func makeOpenSourceLisenceItems() -> [CarteItem] {
        var opensourceLienseItems = [CarteItem]()
        
        var rxSwiftItem = CarteItem(name: "RxSwift")
        rxSwiftItem.licenseText =
        """
        The MIT License Copyright © 2015 Krunoslav Zaher, Shai Mishali All rights reserved.

        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
        """
        opensourceLienseItems.append(rxSwiftItem)
        
        var snapkitItem = CarteItem(name: "SnapKit")
        snapkitItem.licenseText =
        """
        Copyright (c) 2011-Present SnapKit Team - https://github.com/SnapKit

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in
        all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
        THE SOFTWARE.
        """
        opensourceLienseItems.append(snapkitItem)
        
        var moyaItem = CarteItem(name: "Moya")
        moyaItem.licenseText =
        """
        The MIT License (MIT)

        Copyright (c) 2014-present Artsy, Ash Furrow

        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
        """
        opensourceLienseItems.append(moyaItem)
        
        var alamofireItem = CarteItem(name: "Alamofire")
        alamofireItem.licenseText =
        """
        Copyright (c) 2014-2021 Alamofire Software Foundation (http://alamofire.org/)

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in
        all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
        THE SOFTWARE.
        """
        opensourceLienseItems.append(alamofireItem)
        
        var kingfisherItem = CarteItem(name: "Kingfisher")
        kingfisherItem.licenseText =
        """
        The MIT License (MIT)

        Copyright (c) 2019 Wei Wang

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
        """
        opensourceLienseItems.append(kingfisherItem)
        
        var activeLabelItem = CarteItem(name: "ActiveLabel")
        activeLabelItem.licenseText =
        """
        The MIT License (MIT)

        Copyright (c) 2015 Optonaut

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
        """
        opensourceLienseItems.append(activeLabelItem)
        
        var thenItem = CarteItem(name: "Then")
        thenItem.licenseText =
        """
        The MIT License (MIT)

        Copyright (c) 2015 Suyeol Jeon (xoul.kr)

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
        """
        opensourceLienseItems.append(thenItem)
        
        return opensourceLienseItems
    }
    
}
