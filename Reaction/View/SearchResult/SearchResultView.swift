import SwiftUI

struct SearchResultView: View {
    @StateObject var viewModel: SearchResultViewModel

    init(searchResultType: SearchTargetType, withoutCheck: Bool, firstCategories: [FirstCategory]) {
        _viewModel = StateObject(wrappedValue: SearchResultViewModel(searchResultType: searchResultType, withoutCheck: withoutCheck, firstCategories: firstCategories))
    }

    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.reactionMechanisms) { (reactionMechanism: ReactionMechanism) in
                        ReactionListRow(reactionMechanism: reactionMechanism, showingThmbnail: $viewModel.showingThmbnail, selectJapanese: $viewModel.selectJapanese)
                    }
                }
                .padding(.bottom, 62)
            }

            if viewModel.isFetching {
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .padding(36)
                    .background(Color(.appMainText).opacity(0.5))
                    .cornerRadius(24)
            }

//            VStack {
//                Spacer()
//                AdmobBannerView(adUnitID: ADMOB_UNIT_ID)
//            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .navigationTitle(viewModel.navigationTitle)
    }
}

struct SearchResult_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(searchResultType: .reactant, withoutCheck: true, firstCategories: [])
    }
}
