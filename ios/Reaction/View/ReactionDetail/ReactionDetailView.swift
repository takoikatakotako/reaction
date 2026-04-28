import SwiftUI
import Kingfisher

struct ReactionDetailView: View {
    @State var showingSheet = false
    @State var showingFullScreen = false
    @State var reactionMechanism: ReactionMechanism
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ZStack(alignment: .bottom) {
                    ZoomableScrollView {
                        ReactionDetailContent(localeIdentifier: Locale.current.identifier, reactionMechanism: reactionMechanism)
                            .padding(.bottom, 40)
                    }

                    HStack {
                        Spacer()
                        Button(action: {
                            showingSheet = true
                        }, label: {
                            Image(systemName: "square.and.arrow.up")
                                .renderingMode(.template)
                                .colorMultiply(.black)
                                .padding(16)
                                .background(Color.gray)
                                .cornerRadius(16)
                                .padding(.trailing, 16)
                        })
                        .padding(.bottom, 8)
                    }
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
        .sheet(isPresented: $showingSheet, content: {
            ActivityViewController(activityItems: [URL(string: "https://chemist.swiswiswift.com/reaction/\(reactionMechanism.id)")!])
        })
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

// struct ReactionDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ReactionDetailView(selectJapanese: false, reactionMechanism: ReactionMechanism.mock())
//        }
//    }
// }
