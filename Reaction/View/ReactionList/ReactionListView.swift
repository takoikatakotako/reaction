import SwiftUI

struct ReactionListView: View {
    @StateObject var viewState: ReactionListViewState

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ZStack(alignment: .trailing) {
                        TextField("Type your search", text: $viewState.searchText)
                        if !viewState.searchText.isEmpty {
                            Button(action: {
                                viewState.clearSearchText()
                            }) {
                                Image(systemName: "delete.left")
                                    .foregroundColor(Color(UIColor.opaqueSeparator))
                            }
                        }
                    }

                    ForEach(viewState.showingReactions) { (reactionMechanism: ReactionMechanism) in
                        Button {
                            viewState.tapped(reactionMechanism: reactionMechanism)
                        } label: {
                            ReactionListRow(reactionMechanism: reactionMechanism, showingThmbnail: $viewState.showingThmbnail, selectJapanese: $viewState.selectJapanese)
                        }
                        .disabled(viewState.isFetching)
                    }
                }
                .listStyle(.plain)

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
                ReactionDetailView(selectJapanese: viewState.selectJapanese, reactionMechanism: item)
            }
            .alert("有料プラン", isPresented: $viewState.billingAlert, actions: {
                Button("有料プランを購入", role: .none) {
                    viewState.purchase()
                }
                Button("購入を復元", role: .none) {
                    viewState.restore()
                }
                Button("キャンセル", role: .cancel) {}
            }, message: {
                Text("詳細な反応機構を確認するためには有料プランの購入が必要です。")
            })
            .alert("購入完了", isPresented: $viewState.completeAlert, actions: {
                Button("とじる", role: .cancel) {}
            }, message: {
                Text("購入完了しました、ありがとうございました。")
            })
            .alert("エラー", isPresented: $viewState.errorAlert, actions: {
                Button("とじる", role: .cancel) {}
            }, message: {
                Text("有料プランの購入、復元に失敗しました。")
            })

            .sheet(item: $viewState.sheet) { (item: ReactionListViewSheet) in
                switch item {
                case .developer:
                    DeveloperView()
                }
            }
            .navigationTitle("List")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    viewState.sheet = .developer
                }, label: {
                    Text("Info")
                })
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ReactionListView(viewState: ReactionListViewState(showingThmbnail: true, selectJapanese: false))
}
