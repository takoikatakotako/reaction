import SwiftUI
import SDWebImageSwiftUI

struct ReactionDetailView: View {
    let selectJapanese: Bool
    @State var showingSheet = false
    @State var showingFullScreen = false
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
                HStack {
                    Button(action: {
                        let value = UIInterfaceOrientation.landscapeRight.rawValue
                        UIDevice.current.setValue(value, forKey: "orientation")
                        showingFullScreen = true
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                    })

                    Button(action: {
                        showingSheet = true
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                    })
                }
        )
        .fullScreenCover(isPresented: $showingFullScreen) {
            ReactionDetailFullScreenView(selectJapanese: selectJapanese, reactionMechanism: reactionMechanism)
        }
        .sheet(isPresented: $showingSheet, content: {
             ActivityViewController(activityItems: [URL(string: "https://chemist.swiswiswift.com/reaction/\(reactionMechanism.directoryName)")!])
        })
    }
}

struct ReactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReactionDetailView(selectJapanese: false, reactionMechanism: ReactionMechanism.mock())
        }
    }
}
