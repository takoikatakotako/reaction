import SwiftUI

struct ReactionListRowImage: View {
    let imageUrl: URL
    let placeHolderName: String

    @Environment(\.colorScheme) var colorScheme

    var isDarkMode: Bool {
        return colorScheme == .dark
    }

    var body: some View {
        if isDarkMode {
            AsyncImage(url: imageUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .colorInvert()
            } placeholder: {
                Image(placeHolderName)
                    .resizable()
                    .scaledToFit()
                    .colorInvert()
            }
        } else {
            AsyncImage(url: imageUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image(placeHolderName)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}
