import SwiftUI
import Kingfisher

struct ReactionDetailView: View {
    @State var showingFullScreen = false
    @State var reactionMechanism: ReactionMechanism
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ZoomableScrollView {
                    ReactionDetailContent(localeIdentifier: Locale.current.identifier, reactionMechanism: reactionMechanism)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing:
                Button(action: {
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))

                    showingFullScreen = true
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
        )
        .fullScreenCover(isPresented: $showingFullScreen) {
            ReactionDetailFullScreenView(localeIdentifier: Locale.current.identifier, reactionMechanism: reactionMechanism)
        }
        .onAppear {
            prefetchImages()
        }
    }

    private func prefetchImages() {
        let allUrls = (reactionMechanism.generalFormulaImageUrls
            + reactionMechanism.mechanismsImageUrls
            + reactionMechanism.exampleImageUrls
            + reactionMechanism.supplementsImageUrls)
            .compactMap { URL(string: $0) }

        guard !allUrls.isEmpty else {
            isLoading = false
            return
        }

        let prefetcher = ImagePrefetcher(urls: allUrls, completionHandler: { _, _, _ in
            DispatchQueue.main.async {
                isLoading = false
            }
        })
        prefetcher.start()
    }
}
