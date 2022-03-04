//
//  ProfileMenuTableViewCell.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/01.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    func configure(_ menuTitle: String) {
        self.titleLabel.text = menuTitle
    }

    @IBOutlet weak var titleLabel: UILabel!
}
