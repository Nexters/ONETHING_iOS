//
//  ProfileMenuTableViewCell.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/01.
//

import UIKit

class ProfileMenuTableViewCell: UITableViewCell {

    func configure(_ menuTitle: String) {
        self.titleLabel.text = menuTitle
    }

    @IBOutlet private weak var titleLabel: UILabel!
    
}
