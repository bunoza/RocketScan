import Combine
import CoreData
import SwiftUI
import VisionKit

class OverviewViewModel: NSObject, ObservableObject {
    @Published var scanModels: [ScanModelCodable] = []
    @Published var errorMessage: String?

    private var cancellable: AnyCancellable?
    
    func onAppear() {
        cancellable = ScanModelCodableStorage
            .shared
            .scanModels
            .eraseToAnyPublisher()
            .sink(
                receiveValue: { scanModels in
                    self.scanModels = scanModels
                }
            )
    }
    
    func getDocumentCameraViewController() -> VNDocumentCameraViewController {
        let vc = VNDocumentCameraViewController()
        vc.delegate = self
        return vc
    }
    
    func removeScanModel(scanModel: ScanModel) {
        ScanModelCodableStorage.shared.removeScanModel(scanModel: scanModel)
    }
    
    func removeImage(scanModel: ScanModel, image: UIImage) {
        ScanModelCodableStorage.shared.removeImage(scanModel: scanModel, image: image)
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
        ScanModelCodableStorage.shared.add(scanModel: scanModelTemp)
        controller.dismiss(animated: true, completion: nil)
    }
}
