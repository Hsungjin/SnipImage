// The Swift Programming Language
// https://docs.swift.org/swift-book
import AVFoundation
import _PhotosUI_SwiftUI

public class checkPermission {
    public static func authorizeCamera(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        default:
            completion(false)
        }
    }
    
    public static func authorizePhotoLibrary(completion: @escaping (Bool) -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                completion(status == .authorized)
            }
        default:
            completion(false)
        }
    }
    
}

public class SnipImage {
    @available(iOS 16.0, *)
    public static var selectImage: PhotosPickerItem?
}
