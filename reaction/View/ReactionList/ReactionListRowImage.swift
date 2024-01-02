import SwiftUI
import SDWebImageSwiftUI

struct ReactionListRowImage: View {
    let imageUrl: URL
    let placeHolderName: String

    @Environment(\.colorScheme) var colorScheme

    var isDarkMode: Bool {
        return colorScheme == .dark
    }

    var body: some View {
        if isDarkMode {
            WebImage(url: imageUrl)
                .resizable()
                .placeholder(Image(placeHolderName))
                .scaledToFit()
                .colorInvert()
        } else {
            WebImage(url: imageUrl)
                .resizable()
                .placeholder(Image(placeHolderName))
                .scaledToFit()
        }
    }
}
