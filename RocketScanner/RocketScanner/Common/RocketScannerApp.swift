import SwiftUI
import CoreData

@main
struct RocketScannerApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            OverviewView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
