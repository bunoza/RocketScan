import Combine
import CoreData
import SwiftUI

class ScanModelCodableStorage: NSObject, ObservableObject {
    var scanModels = CurrentValueSubject<[ScanModelCodable], Never>([])
    
    private let scanModelFetchController: NSFetchedResultsController<ScanModelCodable>
    
    static let shared: ScanModelCodableStorage = ScanModelCodableStorage()
    
    private override init() {
        let fetchRequest = ScanModelCodable.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "timestamp", ascending: false) ]
        
        scanModelFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: PersistenceController.shared.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
                
        scanModelFetchController.delegate = self
        
        do {
            try scanModelFetchController.performFetch()
            scanModels.value = scanModelFetchController.fetchedObjects ?? []
        } catch {
            print("ScanModelCodableStorage: Could not load objects")
        }
    }
    
    func add(scanModel: ScanModel) {
        let context = scanModelFetchController.managedObjectContext
        let model = ScanModelCodable(context: context)
        model.id = scanModel.id
        model.timestamp = scanModel.timestamp
        model.imagesAsBase64 = scanModel.images.map { $0.convertImageToBase64String() }
        do {
            try context.save()
        } catch {
            print("Error saving scanmodel")
        }
    }
    
    func removeScanModel(scanModel: ScanModel) {
        let context = scanModelFetchController.managedObjectContext
        if let model = scanModels.value.filter({ $0.id == scanModel.id }).first {
            context.delete(model)
            do {
                try context.save()
            } catch {
                print("Error saving scanmodel")
            }
        }
    }
    
    func removeImage(scanModel: ScanModel, image: UIImage) {
        let context = scanModelFetchController.managedObjectContext
        if let model = scanModels.value.filter({ $0.id == scanModel.id }).first {
            context.delete(model)
            let newModel = ScanModelCodable(context: context)
            newModel.id = scanModel.id
            newModel.timestamp = scanModel.timestamp
            newModel.imagesAsBase64 = scanModel.images
                .filter { $0 != image }
                .map { $0.convertImageToBase64String() }
            do {
                try context.save()
            } catch {
                print("Error saving scanmodel")
            }
        }
    }
}

extension ScanModelCodableStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let scanModels = controller.fetchedObjects as? [ScanModelCodable] else { return }
        print("Context changed, reloading scans...")
        self.scanModels.value = scanModels
    }
}
