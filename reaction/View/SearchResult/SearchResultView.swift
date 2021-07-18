import SwiftUI

struct SearchResultView: View {
    @StateObject var viewModel: SearchResultViewModel

    init(searchResultType: SearchTargetType, withoutCheck: Bool, firstCategories: [FirstCategory]) {
        _viewModel = StateObject(wrappedValue: SearchResultViewModel(searchResultType: searchResultType, withoutCheck: withoutCheck, firstCategories: firstCategories))
    }
    
    var body: some View {
        
//        VStack {
//            if searchResultType == .reactant {
//                Text("探すのは出発物")
//            } else if searchResultType == .product {
//                Text("探すのは生成物")
//            }
//
//            ForEach(firstCategories) { firstCategory in
//                if firstCategory.check {
//                    Text(firstCategory.name)
//                }
//
//                ForEach(firstCategory.secondCategories) { secondCategory in
//                    if secondCategory.check {
//                        Text(secondCategory.name)
//                    }
//
//                    ForEach(secondCategory.thirdCategories) { thirdCategory in
//                        if thirdCategory.check {
//                            Text(thirdCategory.name)
//                        }
//                    }
//                }
//            }
//
//            if withoutCheck {
//                Text("↑のタグがついているもの以外を探す")
//            } else {
//                Text("↑のタグがついているものを探す")
//            }
//        }
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
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(24)
            }
            
            VStack {
                Spacer()
                AdmobBannerView(adUnitID: ADMOB_UNIT_ID)
            }
        }
        .onAppear {
            viewModel.fetchMechanisms()
        }
    }
}

struct SearchResult_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(searchResultType: .reactant, withoutCheck: true, firstCategories: [])
    }
}
