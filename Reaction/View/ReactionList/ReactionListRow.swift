import SwiftUI

struct ReactionListRow: View {
    let reactionMechanism: ReactionMechanism
    @Binding var showingThmbnail: Bool
    @Binding var selectJapanese: Bool

    @Environment(\.colorScheme) var colorScheme

    var isDarkMode: Bool {
        return colorScheme == .dark
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(selectJapanese ? reactionMechanism.japanese : reactionMechanism.english)
                .foregroundColor(Color(.appMainText))
            if showingThmbnail {
                ReactionListRowImage(imageUrl: reactionMechanism.thmbnailUrl, placeHolderName: "placeholder-list")
            }
        }
    }
}

// struct ReactionListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ReactionListRow(reactionMechanism: ReactionMechanism.mock(), showingThmbnail: true)
//    }
// }
