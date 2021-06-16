import SwiftUI


struct TopCategory: Identifiable {
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
    
    
    @State private var topCategories: [TopCategory] = [
        TopCategory(
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
        TopCategory(
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
        TopCategory(
            name: "アルケン",
            check: true,
            secondCategories: []
        ),
        TopCategory(
            name: "アミン",
            check: true,
            secondCategories: []
        ),
        TopCategory(
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
                        ForEach(topCategories) { topCategory in
                            Button(action: {
                                topCategorySelected(topCategoryId: topCategory.id)
                            }, label: {
                                VStack(alignment: .leading) {
                                    HStack {
                                        if topCategory.check {
                                            Text("■")
                                        } else {
                                            Text("□")
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
                                                Text("■")
                                                    .padding(.leading, 24)
                                            } else {
                                                Text("□")
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
                                                    Text("■")
                                                        .padding(.leading, 48)
                                                } else {
                                                    Text("□")
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
    
    func topCategorySelected(topCategoryId: String) {
        if let index = topCategories.firstIndex(where: { $0.id == topCategoryId}) {
            topCategories[index].check.toggle()
        }
    }
    
    func secondCategorySelected(topCategoryId: String, secondCategoryId: String) {
        if let topIndex = topCategories.firstIndex(where: { $0.id == topCategoryId}),
           let secondIndex = topCategories[topIndex].secondCategories.firstIndex(where: { $0.id == secondCategoryId}) {
            topCategories[topIndex].secondCategories[secondIndex].check.toggle()
        }
    }
    
    func thirdCategorySelected(topCategoryId: String, secondCategoryId: String, thirdCategoryId: String) {
        if let topIndex = topCategories.firstIndex(where: { $0.id == topCategoryId}),
           let secondIndex = topCategories[topIndex].secondCategories.firstIndex(where: { $0.id == secondCategoryId}),
           let thirdIndex = topCategories[topIndex].secondCategories[secondIndex].thirdCategories.firstIndex(where: { $0.id == thirdCategoryId}) {
            topCategories[topIndex].secondCategories[secondIndex].thirdCategories[thirdIndex].check.toggle()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
