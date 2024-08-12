import SwiftUI

struct ReactionListView: View {
    @StateObject var viewState: ReactionListViewState

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    Divider()

                    ZStack(alignment: .trailing) {
                        TextField(String(localized: "common-search"), text: $viewState.searchText)
                        if !viewState.searchText.isEmpty {
                            Button(action: {
                                viewState.clearSearchText()
                            }) {
                                Image(systemName: "delete.left")
                                    .foregroundColor(Color(UIColor.opaqueSeparator))
                            }
                        }
                    }
                    .padding(8)

                    Divider()

                        List(viewState.showingReactions) { (reactionMechanism: ReactionMechanism) in
                            // 言語が変わったタイミングでリロードするため
                            if viewState.reactionMechanismIdentifier == "ja"{
                                Button {
                                    viewState.tapped(reactionMechanism: reactionMechanism)
                                } label: {
                                    ReactionListRow(
                                        reactionMechanism: reactionMechanism,
                                        showingThmbnail: $viewState.showingThmbnail,
                                        localeIdentifier: viewState.reactionMechanismIdentifier
                                    )
                                }
                                .disabled(viewState.isFetching)
                            } else {
                                Button {
                                    viewState.tapped(reactionMechanism: reactionMechanism)
                                } label: {
                                    ReactionListRow(
                                        reactionMechanism: reactionMechanism,
                                        showingThmbnail: $viewState.showingThmbnail,
                                        localeIdentifier: viewState.reactionMechanismIdentifier
                                    )
                                }
                                .disabled(viewState.isFetching)
                            }
                        }
                        .listStyle(.plain)

                }

                if viewState.isFetching {
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .padding(36)
                        .background(Color(.appMainText).opacity(0.5))
                        .cornerRadius(24)
                }
            }
            .onAppear {
                viewState.onAppear()
            }
            .navigationDestination(item: $viewState.destination) { item in
                ReactionDetailView(reactionMechanism: item)
            }
            .alert(String(localized: "subscription-paid-plan"), isPresented: $viewState.billingAlert, actions: {
                Button(String(localized: "subscription-buy-paid-plan"), role: .none) {
                    viewState.purchase()
                }
                Button(String(localized: "subscription-restore-purchase"), role: .none) {
                    viewState.restore()
                }
                Button(String(localized: "common-cancel"), role: .cancel) {}
            }, message: {
                Text(String(localized: "subscription-need-subscription"))
            })
            .alert(String(localized: "subscription-purchase-complete"), isPresented: $viewState.completeAlert, actions: {
                Button(String(localized: "common-close"), role: .cancel) {}
            }, message: {
                Text(String(localized: "subscription-complete"))
            })
            .alert(String(localized: "common-error"), isPresented: $viewState.errorAlert, actions: {
                Button(String(localized: "common-close"), role: .cancel) {}
            }, message: {
                Text(String(localized: "subscription-failed"))
            })
            .sheet(item: $viewState.sheet) { (item: ReactionListViewSheet) in
                switch item {
                case .developer:
                    DeveloperView()
                }
            }
            .navigationTitle(String(localized: "list-title"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    viewState.sheet = .developer
                }, label: {
                    Text(String(localized: "common-info"))
                })
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ReactionListView(viewState: ReactionListViewState(showingThmbnail: true))
}
