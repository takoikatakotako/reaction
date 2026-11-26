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
                        showingThumbnail: $viewModel.showingThumbnail,
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
        .sheet(isPresented: $viewModel.showingPaywall, onDismiss: {
            viewModel.paywallDismissed()
        }) {
            PremiumPaywallView(onUnlocked: {
                viewModel.paywallUnlocked()
            })
        }
        .alert(String(localized: "subscription-purchase-complete"), isPresented: $viewModel.completeAlert, actions: {
            Button(String(localized: "common-close"), role: .cancel) {}
        }, message: {
            Text(String(localized: "subscription-purchase-complete-thank-you"))
        })
        .navigationTitle(viewModel.navigationTitle)
    }
}
