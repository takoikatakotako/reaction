import SwiftUI

class RootViewState: ObservableObject {
    @Published var showThmbnail: Bool
    @Published var  selectedJapanese: Bool

    init() {
        showThmbnail = UserDefaultRepository().showThmbnail
        selectedJapanese = UserDefaultRepository().selectedJapanese
    }
}
