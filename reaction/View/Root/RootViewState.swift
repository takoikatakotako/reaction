import SwiftUI

class RootViewState: ObservableObject {
    @Published var showThmbnail: Bool

    init() {
        showThmbnail = UserDefaultRepository().showThmbnail
    }
}
