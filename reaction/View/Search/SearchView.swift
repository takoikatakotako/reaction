import SwiftUI


struct FirstCategory: Identifiable {
    var id: String {
        return name
    }
    let name: String
    var check: Bool
    var secondCategories: [SecondCategory]
}

struct SecondCategory: Identifiable {
    var id: String {
        return name
    }
    let name: String
    var check: Bool
    var thirdCategories: [ThirdCategory]
}

struct ThirdCategory: Identifiable {
    var id: String {
        return name
    }
    let name: String
    var check: Bool
}

struct SearchView: View {
    @State private var favoriteColor = 0
    
    @State private var firstCategories: [FirstCategory] = [
        FirstCategory(
            name: "カルボニル",
            check: true,
            secondCategories: [
                SecondCategory(
                    name: "アルデヒド",
                    check: true,
                    thirdCategories: []
                ),
                SecondCategory(
                    name: "ケトン",
                    check: true,
                    thirdCategories: []
                ),
                SecondCategory(
                    name: "カルボン酸誘導体",
                    check: true,
                    thirdCategories: [
                        ThirdCategory(name: "エステル", check: true),
                        ThirdCategory(name: "酸無水物", check: true),
                        ThirdCategory(name: "酸ハロゲン化物", check: true),
                        ThirdCategory(name: "アミド", check: true),
                    ]
                ),
            ]
        ),
        FirstCategory(
            name: "ハロゲン",
            check: true,
            secondCategories: [
                SecondCategory(
                    name: "ハロゲン化アルキル",
                    check: true,
                    thirdCategories: []
                ),
                SecondCategory(
                    name: "その他",
                    check: true,
                    thirdCategories: []
                ),
            ]
        ),
        FirstCategory(
            name: "アルケン",
            check: true,
            secondCategories: []
        ),
        FirstCategory(
            name: "アミン",
            check: true,
            secondCategories: []
        ),
        FirstCategory(
            name: "芳香環",
            check: true,
            secondCategories: [
                SecondCategory(
                    name: "ベンゼン",
                    check: true,
                    thirdCategories: []
                ),
                SecondCategory(
                    name: "ヘテロ環",
                    check: true,
                    thirdCategories: []
                ),
            ]
        ),
    ]
    
    
    
    var body: some View {
        
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
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
                                VStack(alignment: .leading) {
                                    HStack {
                                        if topCategory.check {
                                            Image(R.image.searchCheckBox.name)
                                        } else {
                                            Image(R.image.searchCheckBoxOutline.name)
                                        }
                                        Text(topCategory.name)
                                    }
                                    Divider()
                                }
                            })
                            
                            ForEach(topCategory.secondCategories) { secondCategory in
                                Button(action: {
                                    secondCategorySelected(topCategoryId: topCategory.id, secondCategoryId: secondCategory.id)
                                }, label: {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            if secondCategory.check {
                                                Image(R.image.searchCheckBox.name)
                                                    .padding(.leading, 24)
                                            } else {
                                                Image(R.image.searchCheckBoxOutline.name)
                                                    .padding(.leading, 24)
                                            }
                                            Text(secondCategory.name)
                                        }
                                        Divider()
                                    }
                                })
                                
                                ForEach(secondCategory.thirdCategories) { thirdCategory in
                                    
                                    Button(action: {
                                        thirdCategorySelected(topCategoryId: topCategory.id, secondCategoryId: secondCategory.id, thirdCategoryId: thirdCategory.id)
                                    }, label: {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                if thirdCategory.check {
                                                    Image(R.image.searchCheckBox.name)
                                                        .padding(.leading, 48)
                                                } else {
                                                    Image(R.image.searchCheckBoxOutline.name)
                                                        .padding(.leading, 48)
                                                }
                                                Text(thirdCategory.name)
                                            }
                                            Divider()
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
                
                Button(action: {
                    
                }, label: {
                    Text("検索")
                        .padding()
                        .background(Color.red)
                })
                
            }
            .padding(.horizontal, 8)
            .navigationTitle("Search")
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
                }
                // 全てのサードカテゴリがチェックOffの場合はサブカテゴリーをチェックOffにする
                if thirdCategories.filter({ $0.check == false }).count == thirdCategories.count {
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
            }
            // 全てのセカンドカテゴリがチェックOffの場合はファーストカテゴリーをチェックOffにする
            if secondCategories.filter({ $0.check == false }).count == secondCategories.count {
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
