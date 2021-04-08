import SwiftUI

struct ReactionDetailFullScreenView: View {
    @Environment(\.presentationMode) var presentationMode
    let reactionMechanism: ReactionMechanism
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                ReactionDetailContent(selectJapanese: true, reactionMechanism: reactionMechanism)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        let value = UIInterfaceOrientation.portrait.rawValue
                        UIDevice.current.setValue(value, forKey: "orientation")
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "arrow.counterclockwise")
                    })
            )
        }
    }
}

struct ReactionDetailFullScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ReactionDetailFullScreenView(reactionMechanism: ReactionMechanism.mock())
    }
}
