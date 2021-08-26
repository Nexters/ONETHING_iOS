//
//  DailyHabitViewModelable.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/07.
//

import UIKit

protocol DailyHabitViewModelable: AnyObject {
    var contentText: String? { get }
    var dateText: String? { get }
    var timeText: String? { get }
    var defaultPhotoImage: UIImage? { get }
}
