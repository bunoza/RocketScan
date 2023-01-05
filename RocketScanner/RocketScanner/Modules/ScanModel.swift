import Foundation
import SwiftUI

class ScanModel: Hashable {
    let id: UUID
    let timestamp: Date
    var images: [UIImage]
    
    init(
        images: [UIImage]
    ) {
        self.id = UUID()
        self.timestamp = Date()
        self.images = images
    }
    
    static func == (lhs: ScanModel, rhs: ScanModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
