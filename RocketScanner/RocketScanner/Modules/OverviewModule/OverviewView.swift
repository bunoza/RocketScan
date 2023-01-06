import SwiftUI
import VisionKit
import CoreData

struct OverviewView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.timestamp, order: .reverse)
        ]
    ) var scanModels: FetchedResults<ScanModelCodable>
    
    @StateObject private var viewModel: OverviewViewModel
    @State private var showInfoView: Bool = false
    
    init() {
        self._viewModel = .init(wrappedValue: OverviewViewModel())
    }
    
    var body: some View {
        NavigationView {
            if let error = viewModel.errorMessage {
                Text(error)
            } else {
                renderList()
            }
        }
    }
    
    func renderImageSingle(scanModel: ScanModel) -> some View {
        Section (
            header: Text(scanModel.timestamp.formatted(date: .complete, time: .complete))
        ) {
            renderImage(image: scanModel.images[0])
                .contextMenu {
                    Button {
                        openShareSheet(activityItems: scanModel.images)
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    Button {
                        if let model = scanModels.filter({ $0.id == scanModel.id }).first
                        {
                            moc.delete(model)
                            try? moc.save()
                        }
                    } label: {
                        Label("Delete", systemImage: "delete.left")
                    }
                }
        }
    }
    
    func renderImageBatch(scanModel: ScanModel) -> some View {
        Section {
            ForEach(scanModel.images, id: \.self) { image in
                renderImage(image: image)
                    .contextMenu {
                        Button {
                            openShareSheet(activityItems: scanModel.images)
                        } label: {
                            Label("Share batch", systemImage: "square.and.arrow.up")
                        }
                        Button {
                            openShareSheet(activityItems: [image])
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        Button {
                            if let model = scanModels.filter({ $0.id == scanModel.id }).first
                            {
                                moc.delete(model)
                                try? moc.save()
                            }
                        } label: {
                            Label("Delete batch", systemImage: "delete.left")
                        }
                        Button {
                            if let model = scanModels.filter({ $0.id == scanModel.id }).first
                            {
                                model.imagesAsBase64 = scanModel.images.filter { $0 != image }.map { $0.convertImageToBase64String() }
                                try? moc.save()
                            }
                        } label: {
                            Label("Delete", systemImage: "delete.left")
                        }
                    }
            }
        } header: {
            Text(scanModel.timestamp.formatted(date: .complete, time: .complete))
        }
    }
    
    func renderList() -> some View {
        List() {
            if scanModels.isEmpty {
                Section {} footer: {
                    Text("To start scanning documents, press + in upper right corner.")
                }
            } else {
                ForEach(
                    scanModels.map {
                        ScanModel(
                            id: $0.id!,
                            timestamp: $0.timestamp!,
                            images: $0.imagesAsBase64!.map { $0.convertBase64StringToImage() }
                        )
                    },
                    id: \.id
                ) { scanModel in
                    if scanModel.images.count == 1 {
                        renderImageSingle(scanModel: scanModel)
                    } else {
                        renderImageBatch(scanModel: scanModel)
                    }
                }
            }
        }
        .animation(.easeInOut, value: scanModels.compactMap { $0.imagesAsBase64 })
        .listStyle(.insetGrouped)
        .navigationTitle("Overview")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarItems(
            leading:
                Button(
                    action: {
                        self.showInfoView = true
                    },
                    label: {
                        NavigationLink {
                            InfoView()
                        } label: {
                            Image(systemName: "info")
                        }
                        
                    }
                ),
            trailing:
                Button(
                    action: {
                        viewModel.didFinishScanning = { scanModel in
                            let model = ScanModelCodable(context: moc)
                            model.id = scanModel.id
                            model.timestamp = scanModel.timestamp
                            model.imagesAsBase64 = scanModel.images.map { $0.convertImageToBase64String() }
                            try moc.save()
                        }
                        UIApplication.keyWindow?.rootViewController?
                            .present(
                                viewModel.getDocumentCameraViewController(),
                                animated: true,
                                completion: nil
                            )
                    },
                    label: {
                        Image(systemName: "plus")
                    }
                )
        )
    }
    
    func openShareSheet(activityItems: [UIImage]) {
        UIApplication
            .keyWindow?
            .rootViewController?
            .present(
                UIActivityViewController(
                    activityItems: activityItems,
                    applicationActivities: nil
                ),
                animated: true
            )
    }
    
    func renderImage(image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView()
    }
}
