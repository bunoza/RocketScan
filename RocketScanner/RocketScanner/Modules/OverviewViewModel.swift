import SwiftUI
import VisionKit

class OverviewViewModel: NSObject, ObservableObject {
    @Published var errorMessage: String?
    @Published var scanModels: [ScanModel] = []
    
    var sortedScanModels: [ScanModel] {
        scanModels.sorted { $0.timestamp > $1.timestamp }
    }
    
    func getDocumentCameraViewController() -> VNDocumentCameraViewController {
        let vc = VNDocumentCameraViewController()
        vc.delegate = self
        return vc
    }
    
    func removeScanModel(scanModel: ScanModel) {
        scanModels.removeAll { $0.id == scanModel.id }
    }
    
    func removeImage(scanModel: ScanModel, image: UIImage) {
        if let index = scanModels.firstIndex(of: scanModel) {
            scanModel.images.removeAll { $0 == image }
            if scanModel.images.isEmpty {
                self.scanModels.remove(at: index)
            } else {
                self.scanModels[index] = scanModel
            }
        }
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
        self.scanModels.append(ScanModel(images: allScanedImages))
        controller.dismiss(animated: true, completion: nil)
    }
}
