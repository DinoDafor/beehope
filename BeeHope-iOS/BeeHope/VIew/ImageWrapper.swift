import UIKit
import Foundation

struct ImageWrapper {
    public let image: UIImage?
    public let imageName: String?
}

extension UIImage {

    var containingBundle: Bundle? {
        imageAsset?.value(forKey: "containingBundle") as? Bundle
    }

    var assetName: String? {
        imageAsset?.value(forKey: "assetName") as? String
    }

}
