import SwiftUI
import SDWebImageSwiftUI

struct CommonWebImage: View {
    let url: URL?
    
    @Environment(\.colorScheme) var colorScheme

    var isDarkMode: Bool {
        return colorScheme == .dark
    }
    
    var body: some View {
        if (isDarkMode) {
            WebImage(url: url)
                .resizable()
                .colorInvert()
        } else {
            WebImage(url: url)
                .resizable()
        }
    }
}
