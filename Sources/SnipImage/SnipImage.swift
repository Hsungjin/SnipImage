// The Swift Programming Language
// https://docs.swift.org/swift-book
import AVFoundation
import PhotosUI
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

public func resizedImageRect(for originalImage: UIImage, targetSize: CGSize) -> CGRect {
    let widthRatio = targetSize.width / originalImage.size.width
    let heightRatio = targetSize.height / originalImage.size.height
    let ratio = min(widthRatio, heightRatio)
    
    let newSize = CGSize(width: originalImage.size.width * ratio, height: originalImage.size.height * ratio)
    let rect = CGRect(x: (targetSize.width - newSize.width) / 2.0,
                      y: (targetSize.height - newSize.height) / 2.0,
                      width: newSize.width,
                      height: newSize.height)
    return rect
}

public func resizeImage(originalImage: UIImage, toSize newSize: CGSize) -> UIImage {
    let format = UIGraphicsImageRendererFormat()
    format.scale = 1
    let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
    
    let resizedImage = renderer.image { context in
        originalImage.draw(in: CGRect(origin: .zero, size: newSize))
    }
    
    return resizedImage
}
