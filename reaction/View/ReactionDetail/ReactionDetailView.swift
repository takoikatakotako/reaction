import SwiftUI
import SDWebImageSwiftUI

struct ReactionDetailView: View {
    let selectJapanese: Bool
    @State var showingSheet = false
    @State var reactionMechanism: ReactionMechanism
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                ReactionDetailContent(selectJapanese: selectJapanese, reactionMechanism: reactionMechanism)
                    .padding(.bottom, 62)
            }
            AdmobBannerView(adUnitID: ADMOB_UNIT_ID)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing:
                Button(action: {
                    let value = UIInterfaceOrientation.landscapeRight.rawValue
                    UIDevice.current.setValue(value, forKey: "orientation")
                    showingSheet = true
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
        )
        .fullScreenCover(isPresented: $showingSheet) {
            ReactionDetailFullScreenView(reactionMechanism: reactionMechanism)
        }
    }
}

struct ReactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReactionDetailView(selectJapanese: false, reactionMechanism: ReactionMechanism.mock())
        }
    }
}
