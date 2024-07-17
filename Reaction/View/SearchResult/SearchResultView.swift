import SwiftUI

struct SearchResultView: View {
    @StateObject var viewModel: SearchResultViewState

    var body: some View {
        ZStack {
            List(viewModel.reactionMechanisms) { (reactionMechanism: ReactionMechanism) in
                Button {
                    viewModel.tapped(reactionMechanism: reactionMechanism)
                } label: {
                    ReactionListRow(
                        reactionMechanism: reactionMechanism,
                        showingThmbnail: $viewModel.showingThmbnail,
                        localeIdentifier: Locale.current.identifier
                    )
                }                
            }
            .listStyle(.plain)
            
            if viewModel.isFetching {
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .padding(36)
                    .background(Color(.appMainText).opacity(0.5))
                    .cornerRadius(24)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .navigationDestination(item: $viewModel.destination) { item in
            ReactionDetailView(reactionMechanism: item)
        }
        .alert(String(localized: "subscription-paid-plan"), isPresented: $viewModel.billingAlert, actions: {
            Button(String(localized: "subscription-buy-paid-plan"), role: .none) {
                viewModel.purchase()
            }
            Button(String(localized: "subscription-restore-purchase"), role: .none) {
                viewModel.restore()
            }
            Button(String(localized: "common-cancel"), role: .cancel) {}
        }, message: {
            Text(String(localized: "subscription-need-subscription"))
        })
        .alert(String(localized: "subscription-purchase-complete"), isPresented: $viewModel.completeAlert, actions: {
            Button(String(localized: "common-close"), role: .cancel) {}
        }, message: {
            Text(String(localized: "subscription-complete"))
        })
        .alert(String(localized: "common-error"), isPresented: $viewModel.errorAlert, actions: {
            Button(String(localized: "common-close"), role: .cancel) {}
        }, message: {
            Text(String(localized: "subscription-failed"))
        })
        .navigationTitle(viewModel.navigationTitle)
    }
}

//struct SearchResult_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultView(searchResultType: .reactant, withoutCheck: true, firstCategories: [])
//    }
//}
