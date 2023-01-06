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
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        images: [UIImage]
    ) {
        self.id = id
        self.timestamp = timestamp
        self.images = images
    }
    
    init(
        model: ScanModelCodable
    ) {
        self.id = model.id ?? UUID()
        self.timestamp = model.timestamp ?? Date()
        self.images = model.imagesAsBase64?.map { $0.convertBase64StringToImage() } ?? []
    }
    
    static func == (lhs: ScanModel, rhs: ScanModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
