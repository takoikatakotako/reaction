import SwiftUI

struct CommonWebImage: View {
    let url: URL?

    @Environment(\.colorScheme) var colorScheme

    var isDarkMode: Bool {
        return colorScheme == .dark
    }

    var body: some View {
        if isDarkMode {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .colorInvert()
            } placeholder: {
                ProgressView()
            }
        } else {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
        }
    }
}
