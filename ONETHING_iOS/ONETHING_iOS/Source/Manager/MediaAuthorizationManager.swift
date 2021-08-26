//
//  MediaAuthorizationManager.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/24.
//

import Foundation
import Photos

class MediaAuthorizationManager {
    
    static let sharedInstance = MediaAuthorizationManager()
    
    func requestCameraAuthorization(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { _ in
                self.requestCameraAuthorization(completion: completion)
            }
        default:
            completion(false)
        }
    }
    
    func requestGalleryAuthorization(completion: @escaping (Bool) -> Void) {
        var status: PHAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            
            if #available(iOS 14.0, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { _ in
                    self.requestGalleryAuthorization(completion: completion)
                }
            } else {
                PHPhotoLibrary.requestAuthorization { _ in
                    self.requestGalleryAuthorization(completion: completion)
                }
            }
        case .limited:
            completion(true)
        default:
            completion(false)
        }
    }
    
}
