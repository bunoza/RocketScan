import SwiftUI
import VisionKit

struct OverviewView: View {
    @StateObject private var viewModel: OverviewViewModel
    
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
    
    func renderList() -> some View {
        List(viewModel.sortedScanModels, id: \.id) { scanModel in
            if viewModel.sortedScanModels.isEmpty {
                Section(content: {}, footer: {Text("To start scanning documents press + sign in upper right corner.")})
            } else {
                if scanModel.images.count == 1 {
                    Section(
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
                                    viewModel.removeScanModel(scanModel: scanModel)
                                } label: {
                                    Label("Delete", systemImage: "delete.left")
                                }
                            }
                    }
                }
                else {
                    Section(
                        header: Text(scanModel.timestamp.formatted(date: .complete, time: .complete))
                    ) {
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
                                        viewModel.removeScanModel(scanModel: scanModel)
                                    } label: {
                                        Label("Delete batch", systemImage: "delete.left")
                                    }
                                    Button {
                                        viewModel.removeImage(scanModel: scanModel, image: image)
                                    } label: {
                                        Label("Delete", systemImage: "delete.left")
                                    }
                                }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Overview")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarItems(
            trailing:
                Button(
                    action: {
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
