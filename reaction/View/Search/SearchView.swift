import SwiftUI

struct SearchView: View {
    @State private var favoriteColor = 0
    
    @State private var firstCategories: [FirstCategory] = [
        FirstCategory(
            name: "Carbonyl",
            tag: "Carbonyl",
            check: true,
            secondCategories: [
                SecondCategory(
                    name: "Aldehyde",
                    tag: "Carbonyl-Aldehyde",
                    check: true,
                    thirdCategories: []
                ),
                SecondCategory(
                    name: "Ketone",
                    tag: "Carbonyl-Ketone",
                    check: true,
                    thirdCategories: []
                ),
                SecondCategory(
                    name: "Carboxylic Acid Derivative",
                    tag: "Carbonyl-Carboxylic_Acid_Drivative-Caboxylic_Acid",
                    check: true,
                    thirdCategories: [
                        ThirdCategory(name: "Ester", tag: "Carbonyl-Carboxylic_Acid_Drivative-Ester", check: true),
                        ThirdCategory(name: "Acid Anhydride", tag: "Carbonyl-Carboxylic_Acid_Drivative-Acid_Anhydride", check: true),
                        ThirdCategory(name: "Acid Halide", tag: "Carbonyl-Carboxylic_Acid_Drivative-Acid_Halide", check: true),
                        ThirdCategory(name: "Amide", tag: "Carbonyl-Carboxylic_Acid_Drivative-Amide", check: true),
                        ThirdCategory(name: "Acid Drivative", tag: "Carbonyl-Carboxylic_Acid_Drivative", check: true),
                    ]
                ),
            ]
        ),
        FirstCategory(
            name: "Halogen",
            tag: "Halogene",
            check: true,
            secondCategories: [
                SecondCategory(
                    name: "Alkyl Halide",
                    tag: "Halogene-AlkylHalide",
                    check: true,
                    thirdCategories: []
                ),
                SecondCategory(
                    name: "Other",
                    tag: "Halogene-Other",
                    check: true,
                    thirdCategories: []
                ),
            ]
        ),
        FirstCategory(
            name: "Alkene/Alkyne",
            tag: "Alkene/Alkyne",
            check: true,
            secondCategories: []
        ),
        FirstCategory(
            name: "Amine",
            tag: "Amine",
            check: true,
            secondCategories: []
        ),
        FirstCategory(
            name: "Alcohol",
            tag: "Alcohol",
            check: true,
            secondCategories: []
        ),
        FirstCategory(
            name: "Aromatic Ring",
            tag: "Aromtic_Ring",
            check: true,
            secondCategories: [
                SecondCategory(
                    name: "Benzene",
                    tag: "Aromtic_Ring-Benzene",
                    check: true,
                    thirdCategories: []
                ),
                SecondCategory(
                    name: "Heterocyclic Compound",
                    tag: "Aromatic_Ring-Hetroaromatic_Ring",
                    check: true,
                    thirdCategories: []
                ),
            ]
        ),
    ]
    
    
    
    var body: some View {
        
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    Picker(selection: $favoriteColor, label: Text("")) {
                        Text("Reactant").tag(0)
                        Text("Product").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    LazyVStack {
                        ForEach(firstCategories) { topCategory in
                            Button(action: {
                                firstCategorySelected(topCategoryId: topCategory.id)
                            }, label: {
                                SearchFirstCategoryRow(check: topCategory.check, name: topCategory.name)
                            })
                            
                            ForEach(topCategory.secondCategories) { secondCategory in
                                Button(action: {
                                    secondCategorySelected(topCategoryId: topCategory.id, secondCategoryId: secondCategory.id)
                                }, label: {
                                    SearchSecondCategoryRow(check: secondCategory.check, name: secondCategory.name)
                                })
                                
                                ForEach(secondCategory.thirdCategories) { thirdCategory in
                                    Button(action: {
                                        thirdCategorySelected(topCategoryId: topCategory.id, secondCategoryId: secondCategory.id, thirdCategoryId: thirdCategory.id)
                                    }, label: {
                                        SearchThirdCategoryRow(check: thirdCategory.check, name: thirdCategory.name)
                                    })
                                }
                            }
                        }
                    }
                    .padding(.bottom, 120)
                }
                
                VStack(spacing: 12) {
                    NavigationLink(destination: SearchResult(searchResultType: getSearchTargetType(), withoutCheck: true, firstCategories: firstCategories)) {
                        Text("チェックしたものを除外")
                            .font(Font.system(size: 18).bold())
                            .foregroundColor(.white)
                            .frame(height: 44)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.gray)
                            .padding(.horizontal, 16)
                            .cornerRadius(16)
                    }
                    
                    NavigationLink(destination: SearchResult(searchResultType: getSearchTargetType(), withoutCheck: false, firstCategories: firstCategories)) {
                        Text("チェックしたものを検索")
                            .font(Font.system(size: 18).bold())
                            .foregroundColor(.white)
                            .frame(height: 44)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.gray)
                            .padding(.horizontal, 16)
                            .cornerRadius(16)
                    }
                }
                .padding(.bottom, 8)
                
            }
            .padding(.horizontal, 8)
            .navigationTitle("Search")
        }
    }
    
    func getSearchTargetType() -> SearchTargetType {
        if favoriteColor == 0 {
            return .reactant
        } else {
            return .product
        }
    }
    
    func firstCategorySelected(topCategoryId: String) {
        guard let firstIndex = firstCategories.firstIndex(where: { $0.id == topCategoryId}) else {
            return
        }
        if firstCategories[firstIndex].check {
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
        guard let topIndex = firstCategories.firstIndex(where: { $0.id == topCategoryId}),
              let secondIndex = firstCategories[topIndex].secondCategories.firstIndex(where: { $0.id == secondCategoryId}) else {
            return
        }
        
        if firstCategories[topIndex].secondCategories[secondIndex].check {
            // セカンドカテゴリにチェックが入っている場合
            checkSecondCategory(firstIndex: topIndex, secondIndex: secondIndex, check: false)
        } else {
            // セカンドカテゴリにチェックが入っていない場合
            checkSecondCategory(firstIndex: topIndex, secondIndex: secondIndex, check: true)
        }
        confirmStatus()
    }
    
    func thirdCategorySelected(topCategoryId: String, secondCategoryId: String, thirdCategoryId: String) {
        if let topIndex = firstCategories.firstIndex(where: { $0.id == topCategoryId}),
           let secondIndex = firstCategories[topIndex].secondCategories.firstIndex(where: { $0.id == secondCategoryId}),
           let thirdIndex = firstCategories[topIndex].secondCategories[secondIndex].thirdCategories.firstIndex(where: { $0.id == thirdCategoryId}) {
            firstCategories[topIndex].secondCategories[secondIndex].thirdCategories[thirdIndex].check.toggle()
        }
        confirmStatus()
    }
    
    private func checkFirstCategory(firstIndex: Int, check: Bool) {
        // ファーストカテゴリ以下のチェックをOn, Offする
        firstCategories[firstIndex].check = check
        // セカンドカテゴリ、サードカテゴリにチェックを外す
        for secondIndex in 0..<firstCategories[firstIndex].secondCategories.count {
            checkSecondCategory(firstIndex: firstIndex, secondIndex: secondIndex, check: check)
        }
    }
    
    private func checkSecondCategory(firstIndex: Int, secondIndex: Int, check: Bool) {
        // サードカテゴリ以下のチェックをOn, Offする
        firstCategories[firstIndex].secondCategories[secondIndex].check = check
        for thirdIndex in 0..<firstCategories[firstIndex].secondCategories[secondIndex].thirdCategories.count {
            firstCategories[firstIndex].secondCategories[secondIndex].thirdCategories[thirdIndex].check = check
        }
    }
    
    private func confirmStatus() {
        for firstIndex in 0..<firstCategories.count {
            // サードカテゴリーを確認し、セカンドカテゴリーを更新
            for secondIndex in 0..<firstCategories[firstIndex].secondCategories.count {
                let thirdCategories = firstCategories[firstIndex].secondCategories[secondIndex].thirdCategories
                // サードカテゴリがない場合は次に
                if thirdCategories.isEmpty {
                    continue
                }
                // 全てのサードカテゴリがチェックOnの場合はサブカテゴリーをチェックOnにする
                if thirdCategories.filter({ $0.check == true }).count == thirdCategories.count {
                    firstCategories[firstIndex].secondCategories[secondIndex].check = true
                } else {
                    firstCategories[firstIndex].secondCategories[secondIndex].check = false
                }
            }
            
            // セカンドカテゴリーを確認し、トップカテゴリーを更新
            let secondCategories = firstCategories[firstIndex].secondCategories
            // セカンドカテゴリーがない場合は次に
            if secondCategories.isEmpty {
                continue
            }
            
            // 全てのセカンドカテゴリがチェックOnの場合はファーストカテゴリーをチェックOnにする
            if secondCategories.filter({ $0.check == true }).count == secondCategories.count {
                firstCategories[firstIndex].check = true
            } else {
                firstCategories[firstIndex].check = false
                
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
