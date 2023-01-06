import CoreData
import SwiftUI
import VisionKit

class OverviewViewModel: NSObject, ObservableObject {
    
    @Published var errorMessage: String?
    var didFinishScanning: ((ScanModel) throws -> ())?
    
    func getDocumentCameraViewController() -> VNDocumentCameraViewController {
        let vc = VNDocumentCameraViewController()
        vc.delegate = self
        return vc
    }
    
    func removeScanModel(scanModel: ScanModel, moc: NSManagedObjectContext) {
        let model = ScanModelCodable(context: moc)
        model.id = scanModel.id
        model.timestamp = scanModel.timestamp
        model.imagesAsBase64 = scanModel.images.map { $0.convertImageToBase64String() }
        moc.delete(model)
    }
    
    func removeImage(scanModel: ScanModel, image: UIImage, moc: NSManagedObjectContext) {
        let model = ScanModelCodable(context: moc)
        model.id = scanModel.id
        model.timestamp = scanModel.timestamp
        model.imagesAsBase64 = scanModel.images.filter { $0 != image }.map { $0.convertImageToBase64String() }
        moc.delete(model)
    }
}

extension OverviewViewModel: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        print("Did Finish With Scan.")
        var allScanedImages: [UIImage] = []
        for i in 0..<scan.pageCount {
            allScanedImages.append(scan.imageOfPage(at:i))
        }
        let scanModelTemp = ScanModel(images: allScanedImages)
        do {
            try self.didFinishScanning?(scanModelTemp)
        } catch (let error) {
            print("Error: \(error)")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
