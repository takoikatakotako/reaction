import SwiftUI

struct CommonImage: View {
    let imageName: String

    @Environment(\.colorScheme) var colorScheme

    var isDarkMode: Bool {
        return colorScheme == .dark
    }

    var body: some View {
        if isDarkMode {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .colorInvert()
        } else {
            Image(imageName)
                .resizable()
                .scaledToFit()
        }
    }
}
