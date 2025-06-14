import SwiftUI

struct ReactionDetailContent: View {
    let localeIdentifier: String
    @State var reactionMechanism: ReactionMechanism

    var body: some View {
        LazyVStack {
            CommonText(text: reactionMechanism.getDisplayTitle(identifier: localeIdentifier), font: Font.system(size: 24))
                .padding(.bottom, 12)

            if !reactionMechanism.generalFormulaImageUrls.isEmpty {
                VStack(spacing: 0) {
                    CommonText(text: String(localized: "common-general-formula"), font: Font.system(size: 14))
                    ForEach(reactionMechanism.generalFormulaImageUrls, id: \.self) { generalFormulaImageUrl in
                        CommonWebImage(url: URL(string: generalFormulaImageUrl))
                            .scaledToFit()
                            .padding()
                    }
                }
            }

            if !reactionMechanism.mechanismsImageUrls.isEmpty {
                VStack(spacing: 0) {
                    CommonText(text: String(localized: "common-reaction-mechanism"), font: Font.system(size: 14))
                    ForEach(reactionMechanism.mechanismsImageUrls, id: \.self) { mechanismsImageUrl in
                        CommonWebImage(url: URL(string: mechanismsImageUrl))
                            .scaledToFit()
                            .padding()
                    }
                }
            }

            if !reactionMechanism.exampleImageUrls.isEmpty {
                VStack(spacing: 0) {
                    CommonText(text: String(localized: "common-example"), font: Font.system(size: 14))
                    ForEach(reactionMechanism.exampleImageUrls, id: \.self) { exampleImageUrl in
                        CommonWebImage(url: URL(string: exampleImageUrl))
                            .scaledToFit()
                            .padding()
                    }
                }
            }

            if !reactionMechanism.supplementsImageUrls.isEmpty {
                VStack(spacing: 0) {
                    CommonText(text: String(localized: "common-supplement"), font: Font.system(size: 14))
                    ForEach(reactionMechanism.supplementsImageUrls, id: \.self) { supplementsImageUrl in
                        CommonWebImage(url: URL(string: supplementsImageUrl))
                            .scaledToFit()
                            .padding()
                    }
                }
            }

            if !reactionMechanism.youtubeUrls.isEmpty {
                VStack(spacing: 0) {
                    CommonText(text: String(localized: "common-movie"), font: Font.system(size: 14))
                    ForEach(reactionMechanism.youtubeUrls, id: \.self) { youtubeUrl in
                        if let youtubeUrl = URL(string: youtubeUrl) {
                            Button {
                                openUrl(url: youtubeUrl)
                            } label: {
                                AsyncImage(url: getYoutubeThmbnailUrlString(youtubeUrl: youtubeUrl)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .padding()
                                } placeholder: {
                                    ProgressView()
                                        .padding()
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.bottom, 16)
    }

    private func getYoutubeThmbnailUrlString(youtubeUrl: URL) -> URL {
        let youtubePath = youtubeUrl.path
        return URL(string: "https://img.youtube.com/vi\(youtubePath)/hqdefault.jpg")!
    }

    private func openUrl(url: URL) {
        UIApplication.shared.open(url)
    }
}

// struct ReactionDetailContent_Previews: PreviewProvider {
//    static var previews: some View {
//        ReactionDetailContent(selectJapanese: true, reactionMechanism: ReactionMechanism.mock())
//    }
// }
