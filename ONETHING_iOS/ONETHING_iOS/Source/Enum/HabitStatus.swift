//
//  HabitStatus.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/06.
//

import Foundation

enum HabitStatus: String {
    case run = "RUN"
    case pass = "PASS"
    case unseenSuccess = "UNSEEN_SUCCESS"
    case success = "SUCCESS"
    case unseenFail = "UNSEEN_FAIL"
    case fail = "FAIL"
    
    var canShowHistoryPage: Bool {
        self == .success || self == .fail || self == .pass
    }
}
