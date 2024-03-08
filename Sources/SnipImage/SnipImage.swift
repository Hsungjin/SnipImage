// The Swift Programming Language
// https://docs.swift.org/swift-book
import AVFoundation
import PhotosUI
import SwiftUI

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

@available(iOS 13.0, *)
public func imageToUIImage(originalImage: Image) -> UIImage {
    let controller = UIHostingController(rootView: originalImage)
    controller.view.layoutIfNeeded()
    
    let renderer = UIGraphicsImageRenderer(size: controller.view.frame.size)
    let image = renderer.image { context in
        controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
    }
    
    return image
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

public func CropInBackground(inputImage: UIImage, cropWidth: Double, cropHeight: Double) async throws -> UIImage {
    
    enum CroppingError: Error {
        case imageNotFound, failedToCrop
    }
    
    let croppingFrame: CGRect
    let scaleFactor: CGFloat
    let processedImageWidth: CGFloat
    let processedImageHeight: CGFloat
    let croppedImage: UIImage
    guard let cgImage: CGImage = inputImage.cgImage else {
        print("image not found")
        throw CroppingError.imageNotFound
    }
    
    // Declaration of cropping frame size
    scaleFactor = inputImage.scale
    processedImageWidth = (inputImage.size.width * scaleFactor) - (cropWidth * scaleFactor)
    processedImageHeight = (inputImage.size.height * scaleFactor) - (cropHeight * scaleFactor)
    
    // Declaration of frame for cropping
    croppingFrame = CGRect(x: 0, y: 0, width: processedImageWidth, height: processedImageHeight)
    
    // Cropping CGImage
    guard let processedCGImage: CGImage = cgImage.cropping(to: croppingFrame) else {
        print("image not found")
        throw CroppingError.failedToCrop
    }
    
    // Convert CGImage to UIImage
    croppedImage = UIImage(cgImage: processedCGImage, scale: scaleFactor, orientation: inputImage.imageOrientation)
    
    return croppedImage
}
