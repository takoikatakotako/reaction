import SwiftUI
import Kingfisher

struct ReactionDetailFullScreenView: View {
    @Environment(\.dismiss) var dismiss

    let localeIdentifier: String
    let reactionMechanism: ReactionMechanism
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            ZStack {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ZoomableScrollView {
                        ReactionDetailContent(localeIdentifier: localeIdentifier, reactionMechanism: reactionMechanism)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                        windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.counterclockwise")
                    })
            )
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

        let prefetcher = ImagePrefetcher(urls: allUrls) { _, _, _ in
            DispatchQueue.main.async {
                isLoading = false
            }
        }
        prefetcher.start()
    }
}

// struct ReactionDetailFullScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReactionDetailFullScreenView(selectJapanese: true, reactionMechanism: ReactionMechanism.mock())
//    }
// }
