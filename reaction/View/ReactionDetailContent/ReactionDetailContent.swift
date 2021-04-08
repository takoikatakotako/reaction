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
        }
        .padding(.vertical, 18)
    }
}

struct ReactionDetailContent_Previews: PreviewProvider {
    static var previews: some View {
        ReactionDetailContent(selectJapanese: true, reactionMechanism: ReactionMechanism.mock())
    }
}
