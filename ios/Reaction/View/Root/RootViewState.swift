import SwiftUI

@MainActor
final class RootViewState: ObservableObject {
    @Published var showThumbnail: Bool

    init() {
        showThumbnail = UserDefaultRepository().showThumbnail
    }
}
