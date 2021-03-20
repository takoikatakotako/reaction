import SwiftUI
import SDWebImageSwiftUI

struct ReactionDetailContent: View {
    @State var reactionMechanism: ReactionMechanism
    
    var body: some View {
        LazyVStack {
            Text(reactionMechanism.english)
                .font(Font.system(size: 24))
                .padding(.bottom, 12)
            
            if !reactionMechanism.generalFormulas.isEmpty {
                VStack(spacing: 0) {
                    Text("GeneralFormula")
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
                    Text("Mechanism")
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
                    Text("Example")
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
                    Text("Supplement")
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
        ReactionDetailContent(reactionMechanism: ReactionMechanism.mock())
    }
}
