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
            Text(reactionMechanism.getDisplayTitle(identifier: localeIdentifier))
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
