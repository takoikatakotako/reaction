import SwiftUI

struct CommonText: View {
    let text: String
    let font: Font

    init(text: String, font: Font) {
        self.text = text
        self.font = font
    }

    var body: some View {
        Text(text)
            .foregroundColor(Color(.appMainText))
    }
}
