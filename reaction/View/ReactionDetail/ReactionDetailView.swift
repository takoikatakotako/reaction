import SwiftUI
import SDWebImageSwiftUI

struct ReactionDetailView: View {
    @State var showingSheet = false
    @State var reactionMechanism: ReactionMechanism
    
    var body: some View {
        ScrollView {
            ReactionDetailContent(reactionMechanism: reactionMechanism)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("全画面") {
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            showingSheet = true
        })
        .fullScreenCover(isPresented: $showingSheet) {
            ReactionDetailFullScreenView(reactionMechanism: reactionMechanism)
        }
    }
}

struct ReactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReactionDetailView(reactionMechanism: ReactionMechanism.mock())
        }
    }
}
