import SwiftUI
import Kingfisher

struct ReactionListRowImage: View {
    let imageUrl: URL
    let placeHolderName: String

    @Environment(\.colorScheme) var colorScheme

    var isDarkMode: Bool {
        return colorScheme == .dark
    }

    var body: some View {
        KFImage(imageUrl)
            .placeholder {
                Image(placeHolderName)
                    .resizable()
                    .scaledToFit()
                    .colorInvert(isDarkMode)
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
