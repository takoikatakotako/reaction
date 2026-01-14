import SwiftUI
import Kingfisher

struct CommonWebImage: View {
    let url: URL?

    @Environment(\.colorScheme) var colorScheme

    var isDarkMode: Bool {
        return colorScheme == .dark
    }

    var body: some View {
        KFImage(url)
            .placeholder {
                ProgressView()
            }
            .fade(duration: 0.25)
            .resizable()
            .scaledToFit()
            .colorInvert(isDarkMode)
    }
}

private extension View {
    @ViewBuilder
    func colorInvert(_ apply: Bool) -> some View {
        if apply {
            self.colorInvert()
        } else {
            self
        }
    }
}
