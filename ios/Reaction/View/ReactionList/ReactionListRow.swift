import SwiftUI

struct ReactionListRow: View {
    let reactionMechanism: ReactionMechanism
    @Binding var showingThmbnail: Bool
    @State var localeIdentifier: String

    @Environment(\.colorScheme) var colorScheme

    var isDarkMode: Bool {
        return colorScheme == .dark
    }

    var body: some View {
        VStack(alignment: .leading) {
            CommonText(text: reactionMechanism.getDisplayTitle(identifier: localeIdentifier), font: Font.system(size: 12))
            if showingThmbnail {
                ReactionListRowImage(imageUrl: URL(string: reactionMechanism.thumbnailImageUrl)!, placeHolderName: "placeholder-list")
            }
        }
    }
}

// struct ReactionListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ReactionListRow(reactionMechanism: ReactionMechanism.mock(), showingThmbnail: true)
//    }
// }
