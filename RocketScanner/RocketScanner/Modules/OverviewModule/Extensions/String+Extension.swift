import SwiftUI

extension String {
    func convertBase64StringToImage() -> UIImage {
        let imageData = Data(base64Encoded: self)
        let image = UIImage(data: imageData!)
        return image!
    }
}
