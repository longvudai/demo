import Foundation
import UIKit
import Photos
import RxSwift

class PhotoWriter {
  enum Errors: Error {
    case couldNotSavePhoto
  }
  
  static func save(image: UIImage) -> Single<String> {
    return Single<String>.create { observer in
      var localIdentifier: String?
      PHPhotoLibrary.shared().performChanges {
        let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
        let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
        localIdentifier = assetPlaceholder?.localIdentifier
      } completionHandler: { success, error in
        DispatchQueue.main.async {
          if let err = error {
            observer(.failure(err))
          } else if let identifier = localIdentifier, success {
            observer(.success(identifier))
          }
        }
      }
      
      return Disposables.create()
    }
  }
}
