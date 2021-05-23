import SwiftUI

struct ReactionDetailFullScreenView: View {
    @Environment(\.presentationMode) var presentationMode
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
                        let value = UIInterfaceOrientation.portrait.rawValue
                        UIDevice.current.setValue(value, forKey: "orientation")
                        presentationMode.wrappedValue.dismiss()
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
