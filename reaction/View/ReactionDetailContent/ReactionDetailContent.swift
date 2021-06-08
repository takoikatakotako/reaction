import SwiftUI
import SDWebImageSwiftUI

struct ReactionDetailContent: View {
    let selectJapanese: Bool
    @State var reactionMechanism: ReactionMechanism
    
    var body: some View {
        LazyVStack {
            Text(selectJapanese ? reactionMechanism.japanese : reactionMechanism.english)
                .font(Font.system(size: 24))
                .padding(.bottom, 12)
            
            if !reactionMechanism.generalFormulas.isEmpty {
                VStack(spacing: 0) {
                    Text(selectJapanese ? "一般式" : "General Formula")
                    ForEach(reactionMechanism.generalFormulas, id: \.self) { generalFormula in
                        WebImage(url: URL(string: reactionMechanism.reactionUrlString + generalFormula.imageName))
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                }
            }
            
            if !reactionMechanism.mechanisms.isEmpty {
                VStack(spacing: 0) {
                    Text(selectJapanese ? "反応機構" : "Mechanism")
                    ForEach(reactionMechanism.mechanisms, id: \.self) { mechanism in
                        WebImage(url: URL(string: reactionMechanism.reactionUrlString + mechanism.imageName))
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                }
            }
            
            if !reactionMechanism.examples.isEmpty {
                VStack(spacing: 0) {
                    Text(selectJapanese ?  "例" : "Example")
                    ForEach(reactionMechanism.examples, id: \.self) { example in
                        WebImage(url: URL(string: reactionMechanism.reactionUrlString + example.imageName))
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                }
            }
            
            if !reactionMechanism.supplements.isEmpty {
                VStack(spacing: 0) {
                    Text(selectJapanese ?  "補足" : "Supplement")
                    ForEach(reactionMechanism.supplements, id: \.self) { supplement in
                        WebImage(url: URL(string: reactionMechanism.reactionUrlString + supplement.imageName))
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                }
            }
            
            if !reactionMechanism.youtubeLinks.isEmpty {
                VStack(spacing: 0) {
                    Text(selectJapanese ?  "動画" : "Movie")
                    ForEach(reactionMechanism.youtubeLinks, id: \.self) { youtubeLink in
                        if let youtubeUrl = URL(string: youtubeLink),
                           let youtubeThmbnailUrl = getYoutubeThmbnailUrlString(youtubeUrl: youtubeUrl) {
                            Button {
                                openUrl(url: youtubeUrl)
                            } label: {
                                WebImage(url: youtubeThmbnailUrl)
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical, 18)
    }
    
    private func getYoutubeThmbnailUrlString(youtubeUrl: URL) -> URL {
        let youtubePath = youtubeUrl.path
        return URL(string: "https://img.youtube.com/vi\(youtubePath)/0.jpg")!
    }
    
    private func openUrl(url: URL) {
        UIApplication.shared.open(url)
    }
}

struct ReactionDetailContent_Previews: PreviewProvider {
    static var previews: some View {
        ReactionDetailContent(selectJapanese: true, reactionMechanism: ReactionMechanism.mock())
    }
}
