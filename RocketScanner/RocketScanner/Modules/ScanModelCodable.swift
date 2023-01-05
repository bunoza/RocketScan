import Foundation
import SwiftUI

public class ScanModelCodable: NSObject, NSCoding {
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: Key.id.rawValue)
        coder.encode(timestamp, forKey: Key.timestamp.rawValue)
        coder.encode(imagesAsBase64, forKey: Key.imagesAsBase64.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let id = coder.decodeObject(forKey: Key.id.rawValue) as! UUID
        let timestamp = coder.decodeObject(forKey: Key.timestamp.rawValue) as! Date
        let imagesAsBase64 = coder.decodeObject(forKey: Key.imagesAsBase64.rawValue) as! [String]
        
        self.init(id: id, timestamp: timestamp, imagesAsBase64: imagesAsBase64)
    }
    
    public let id: UUID
    public let timestamp: Date
    public let imagesAsBase64: [String]
    
    enum Key: String {
        case id = "id"
        case timestamp = "timestamp"
        case imagesAsBase64 = "imagesAsBase64"
    }
    
    init(scanModel: ScanModel) {
        self.id = scanModel.id
        self.timestamp = scanModel.timestamp
        self.imagesAsBase64 = scanModel.images.map { $0.convertImageToBase64String() }
    }
    
    init(
        id: UUID,
        timestamp: Date,
        imagesAsBase64: [String]
    ) {
        self.id = id
        self.timestamp = timestamp
        self.imagesAsBase64 = imagesAsBase64
    }
    
    static func == (lhs: ScanModelCodable, rhs: ScanModelCodable) -> Bool {
        return lhs.id == rhs.id
    }
}
