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
        NavigationLink(
            destination: ReactionDetailView(selectJapanese: selectJapanese, reactionMechanism: reactionMechanism)) {
            VStack(alignment: .leading) {
                Text(selectJapanese ? reactionMechanism.japanese : reactionMechanism.english)
                    .foregroundColor(Color(.appMainText))
                if showingThmbnail {
                    ReactionListRowImage(imageUrl: reactionMechanism.thmbnailUrl, placeHolderName: "placeholder-list")
                }
                Divider()
            }
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
    }
}

// struct ReactionListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ReactionListRow(reactionMechanism: ReactionMechanism.mock(), showingThmbnail: true)
//    }
// }
