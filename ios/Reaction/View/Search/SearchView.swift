import SwiftUI

struct SearchView: View {
    @StateObject var viewState: SearchViewState

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    Picker(selection: $viewState.searchType, label: Text("")) {
                        Text(String(localized: "setting-reactant")).tag(0)
                        Text(String(localized: "search-product")).tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(8)

                    LazyVStack {
                        ForEach(viewState.firstCategories) { topCategory in
                            Button(action: {
                                firstCategorySelected(topCategoryId: topCategory.id)
                            }, label: {
                                SearchFirstCategoryRow(
                                    check: topCategory.check,
                                    name: topCategory.getDisplayName(laungageIdentifier: viewState.reactionMechanismIdentifier)
                                )
                            })

                            ForEach(topCategory.secondCategories) { secondCategory in
                                Button(action: {
                                    secondCategorySelected(
                                        topCategoryId: topCategory.id,
                                        secondCategoryId: secondCategory.id
                                    )
                                }, label: {
                                    SearchSecondCategoryRow(
                                        check: secondCategory.check,
                                        name: secondCategory.getDisplayName(laungageIdentifier: viewState.reactionMechanismIdentifier)
                                    )
                                })

                                ForEach(secondCategory.thirdCategories) { thirdCategory in
                                    Button(action: {
                                        thirdCategorySelected(topCategoryId: topCategory.id, secondCategoryId: secondCategory.id, thirdCategoryId: thirdCategory.id)
                                    }, label: {
                                        SearchThirdCategoryRow(
                                            check: thirdCategory.check,
                                            name: thirdCategory.getDisplayName(laungageIdentifier: viewState.reactionMechanismIdentifier)
                                        )
                                    })
                                }
                            }
                        }
                    }
                    .padding(.bottom, 120)
                }

                VStack(spacing: 12) {
                    NavigationLink(destination: SearchResultView(viewModel: SearchResultViewState(searchResultType: getSearchTargetType(), withoutCheck: true, firstCategories: viewState.firstCategories))) {
                        HStack {
                            Spacer()
                            Text(String(localized: "search-search-for-exclude-checked-items"))
                                .font(Font.system(size: 18).bold())
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .frame(height: 44)
                        .padding(.horizontal, 32)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }

                    NavigationLink(destination: SearchResultView(viewModel: SearchResultViewState(searchResultType: getSearchTargetType(), withoutCheck: false, firstCategories: viewState.firstCategories))) {
                        HStack {
                            Spacer()
                            Text(String(localized: "search-search-for-checked-items"))
                                .font(Font.system(size: 18).bold())
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .frame(height: 44)
                        .padding(.horizontal, 32)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                }
                .padding(.bottom, 8)
            }
            .onAppear {
                viewState.onAppear()
            }
            .padding(.horizontal, 8)
            .navigationTitle(String(localized: "search-title"))
            .navigationBarTitleDisplayMode(.inline)
        }

    }

    func getSearchTargetType() -> SearchTargetType {
        if viewState.searchType == 0 {
            return .reactant
        } else {
            return .product
        }
    }

    func firstCategorySelected(topCategoryId: String) {
        guard let firstIndex = viewState.firstCategories.firstIndex(where: { $0.id == topCategoryId}) else {
            return
        }
        if viewState.firstCategories[firstIndex].check {
            // ファーストカテゴリにチェックが入っている場合
            // セカンドカテゴリ、サードカテゴリにチェックを入れる
            checkFirstCategory(firstIndex: firstIndex, check: false)

        } else {
            // ファーストカテゴリにチェックが入っていない場合
            // セカンドカテゴリ、サードカテゴリにチェックを外す
            checkFirstCategory(firstIndex: firstIndex, check: true)
        }

        confirmStatus()
    }

    func secondCategorySelected(topCategoryId: String, secondCategoryId: String) {
        guard let topIndex = viewState.firstCategories.firstIndex(where: { $0.id == topCategoryId}),
              let secondIndex = viewState.firstCategories[topIndex].secondCategories.firstIndex(where: { $0.id == secondCategoryId}) else {
            return
        }

        if viewState.firstCategories[topIndex].secondCategories[secondIndex].check {
            // セカンドカテゴリにチェックが入っている場合
            checkSecondCategory(firstIndex: topIndex, secondIndex: secondIndex, check: false)
        } else {
            // セカンドカテゴリにチェックが入っていない場合
            checkSecondCategory(firstIndex: topIndex, secondIndex: secondIndex, check: true)
        }
        confirmStatus()
    }

    func thirdCategorySelected(topCategoryId: String, secondCategoryId: String, thirdCategoryId: String) {
        if let topIndex = viewState.firstCategories.firstIndex(where: { $0.id == topCategoryId}),
           let secondIndex = viewState.firstCategories[topIndex].secondCategories.firstIndex(where: { $0.id == secondCategoryId}),
           let thirdIndex = viewState.firstCategories[topIndex].secondCategories[secondIndex].thirdCategories.firstIndex(where: { $0.id == thirdCategoryId}) {
            viewState.firstCategories[topIndex].secondCategories[secondIndex].thirdCategories[thirdIndex].check.toggle()
        }
        confirmStatus()
    }

    private func checkFirstCategory(firstIndex: Int, check: Bool) {
        // ファーストカテゴリ以下のチェックをOn, Offする
        viewState.firstCategories[firstIndex].check = check
        // セカンドカテゴリ、サードカテゴリにチェックを外す
        for secondIndex in 0..<viewState.firstCategories[firstIndex].secondCategories.count {
            checkSecondCategory(firstIndex: firstIndex, secondIndex: secondIndex, check: check)
        }
    }

    private func checkSecondCategory(firstIndex: Int, secondIndex: Int, check: Bool) {
        // サードカテゴリ以下のチェックをOn, Offする
        viewState.firstCategories[firstIndex].secondCategories[secondIndex].check = check
        for thirdIndex in 0..<viewState.firstCategories[firstIndex].secondCategories[secondIndex].thirdCategories.count {
            viewState.firstCategories[firstIndex].secondCategories[secondIndex].thirdCategories[thirdIndex].check = check
        }
    }

    private func confirmStatus() {
        for firstIndex in 0..<viewState.firstCategories.count {
            // サードカテゴリーを確認し、セカンドカテゴリーを更新
            for secondIndex in 0..<viewState.firstCategories[firstIndex].secondCategories.count {
                let thirdCategories = viewState.firstCategories[firstIndex].secondCategories[secondIndex].thirdCategories
                // サードカテゴリがない場合は次に
                if thirdCategories.isEmpty {
                    continue
                }
                // 全てのサードカテゴリがチェックOnの場合はサブカテゴリーをチェックOnにする
                if thirdCategories.filter({ $0.check == true }).count == thirdCategories.count {
                    viewState.firstCategories[firstIndex].secondCategories[secondIndex].check = true
                } else {
                    viewState.firstCategories[firstIndex].secondCategories[secondIndex].check = false
                }
            }

            // セカンドカテゴリーを確認し、トップカテゴリーを更新
            let secondCategories = viewState.firstCategories[firstIndex].secondCategories
            // セカンドカテゴリーがない場合は次に
            if secondCategories.isEmpty {
                continue
            }

            // 全てのセカンドカテゴリがチェックOnの場合はファーストカテゴリーをチェックOnにする
            if secondCategories.filter({ $0.check == true }).count == secondCategories.count {
                viewState.firstCategories[firstIndex].check = true
            } else {
                viewState.firstCategories[firstIndex].check = false
            }
        }
    }
}

#Preview {
    SearchView(viewState: SearchViewState())
}
