import SwiftUI

extension UIImage {
    func convertImageToBase64String() -> String {
        return self.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
}
