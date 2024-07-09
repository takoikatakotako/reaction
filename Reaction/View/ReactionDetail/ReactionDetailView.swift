import SwiftUI

struct ReactionDetailView: View {
    @State var showingSheet = false
    @State var showingFullScreen = false
    @State var reactionMechanism: ReactionMechanism
    

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                ReactionDetailContent(localeIdentifier: Locale.current.identifier, reactionMechanism: reactionMechanism)
                    .padding(.bottom, 40)
            }

            HStack {
                Spacer()
                Button(action: {
                    showingSheet = true
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .renderingMode(.template)
                        .colorMultiply(.black)
                        .padding(16)
                        .background(Color.gray)
                        .cornerRadius(16)
                        .padding(.trailing, 16)
                })
                .padding(.bottom, 8)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing:
                Button(action: {
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))

                    showingFullScreen = true
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
        )
        .fullScreenCover(isPresented: $showingFullScreen) {
            ReactionDetailFullScreenView(localeIdentifier: Locale.current.identifier, reactionMechanism: reactionMechanism)
        }
        .sheet(isPresented: $showingSheet, content: {
            ActivityViewController(activityItems: [URL(string: "https://chemist.swiswiswift.com/reaction/\(reactionMechanism.directoryName)")!])
        })
    }
}

//struct ReactionDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ReactionDetailView(selectJapanese: false, reactionMechanism: ReactionMechanism.mock())
//        }
//    }
//}
