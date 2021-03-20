import SwiftUI

struct ReactionDetailFullScreenView: View {
    @Environment(\.presentationMode) var presentationMode
    let reactionMechanism: ReactionMechanism
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                ReactionDetailContent(reactionMechanism: reactionMechanism)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("閉じる") {
                let value = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ReactionDetailFullScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ReactionDetailFullScreenView(reactionMechanism: ReactionMechanism.mock())
    }
}
