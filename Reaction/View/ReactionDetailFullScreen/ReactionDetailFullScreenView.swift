import SwiftUI

struct ReactionDetailFullScreenView: View {
    @Environment(\.dismiss) var dismiss

    let selectJapanese: Bool
    let reactionMechanism: ReactionMechanism

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                ReactionDetailContent(selectJapanese: selectJapanese, reactionMechanism: reactionMechanism)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                        windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.counterclockwise")
                    })
            )
        }
    }
}

struct ReactionDetailFullScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ReactionDetailFullScreenView(selectJapanese: true, reactionMechanism: ReactionMechanism.mock())
    }
}
