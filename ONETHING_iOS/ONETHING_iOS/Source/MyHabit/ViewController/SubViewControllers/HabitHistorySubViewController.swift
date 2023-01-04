//
//  HabitHistorySubViewController.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 05/01/2023.
//

import UIKit

protocol HabitHistorySubViewController: UIViewController {
    var viewModel: HabitHistoryViewModel { get }
    var delegate: HabitHistorySubViewControllerDelegate? { get set }
}
