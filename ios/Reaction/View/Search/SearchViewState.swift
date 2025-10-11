import Foundation

class SearchViewState: ObservableObject {
    @Published var searchType = 0
    @Published var firstCategories: [FirstCategory] = [
        FirstCategory(
            name: "Carbonyl",
            englishName: "Carbonyl",
            japaneseName: "カルボニル",
            tag: "Carbonyl",
            check: true,
            secondCategories: [
                SecondCategory(
                    name: "Aldehyde",
                    englishName: "Aldehyde",
                    japaneseName: "アルデヒド",
                    tag: "Carbonyl-Aldehyde",
                    check: true,
                    thirdCategories: []
                ),
                SecondCategory(
                    name: "Ketone",
                    englishName: "Ketone",
                    japaneseName: "ケトン",
                    tag: "Carbonyl-Ketone",
                    check: true,
                    thirdCategories: []
                ),
                SecondCategory(
                    name: "Carboxylic Acid Derivative",
                    englishName: "Carboxylic Acid Derivative",
                    japaneseName: "カルボン酸誘導体",
                    tag: "Carbonyl-Carboxylic_Acid_Derivative",
                    check: true,
                    thirdCategories: [
                        ThirdCategory(
                            name: "Carboxilic Acid",
                            englishName: "Carboxilic Acid",
                            japaneseName: "カルボン酸",
                            tag: "Carbonyl-Carboxylic_Carboxilic-Acid",
                            check: true
                        ),
                        ThirdCategory(
                            name: "Ester",
                            englishName: "Ester",
                            japaneseName: "エステル",
                            tag: "Carbonyl-Carboxylic_Acid_Derivative-Ester",
                            check: true
                        ),
                        ThirdCategory(
                            name: "Acid Anhydride",
                            englishName: "Acid Anhydride",
                            japaneseName: "酸無水物",
                            tag: "Carbonyl-Carboxylic_Acid_Derivative-Acid_Anhydride",
                            check: true
                        ),
                        ThirdCategory(
                            name: "Acid Halide",
                            englishName: "Acid Halide",
                            japaneseName: "酸ハロゲン化物",
                            tag: "Carbonyl-Carboxylic_Acid_Derivative-Acid_Halide",
                            check: true
                        ),
                        ThirdCategory(
                            name: "Amide",
                            englishName: "Amide",
                            japaneseName: "アミド",
                            tag: "Carbonyl-Carboxylic_Acid_Derivative-Amide",
                            check: true
                        ),
                        ThirdCategory(
                            name: "Acid Derivative",
                            englishName: "Acid Derivative",
                            japaneseName: "酸誘導体",
                            tag: "Carbonyl-Carboxylic_Acid_Derivative-Acid_Derivative",
                            check: true
                        )
                    ]
                )
            ]
        ),
        FirstCategory(
            name: "Halogen",
            englishName: "Halogen",
            japaneseName: "ハロゲン",
            tag: "Halogen",
            check: true,
            secondCategories: [
                SecondCategory(
                    name: "Alkyl Halide",
                    englishName: "Alkyl Halide",
                    japaneseName: "ハロゲン化アルキル",
                    tag: "Halogen-Alkyl_Halide",
                    check: true,
                    thirdCategories: []
                ),
                SecondCategory(
                    name: "Other",
                    englishName: "Other",
                    japaneseName: "その他",
                    tag: "Halogen-Other",
                    check: true,
                    thirdCategories: []
                )
            ]
        ),
        FirstCategory(
            name: "Alkene/Alkyne",
            englishName: "Alkene/Alkyne",
            japaneseName: "アルケン/アルキン",
            tag: "Alkene/Alkyne",
            check: true,
            secondCategories: []
        ),
        FirstCategory(
            name: "Amine",
            englishName: "Amine",
            japaneseName: "アミン",
            tag: "Amine",
            check: true,
            secondCategories: []
        ),
        FirstCategory(
            name: "Alcohol",
            englishName: "Alcohol",
            japaneseName: "アルコール",
            tag: "Alcohol",
            check: true,
            secondCategories: []
        ),
        FirstCategory(
            name: "Aromatic Ring",
            englishName: "Aromatic Ring",
            japaneseName: "芳香環",
            tag: "Aromtic_Ring",
            check: true,
            secondCategories: [
                SecondCategory(
                    name: "Benzene",
                    englishName: "Benzene",
                    japaneseName: "ベンゼン",
                    tag: "Aromatic_Ring-Benzene",
                    check: true,
                    thirdCategories: []
                ),
                SecondCategory(
                    name: "Heterocyclic Compound",
                    englishName: "Heterocyclic Compound",
                    japaneseName: "複素環化合物",
                    tag: "Aromatic_Ring-Heteroaromatic_Ring",
                    check: true,
                    thirdCategories: []
                )
            ]
        )
    ]

    // 言語
    @Published var reactionMechanismIdentifier: String

    private let userDefaultRepository = UserDefaultRepository()

    init() {
        self.reactionMechanismIdentifier = userDefaultRepository.reactionMechanismLanguage
    }

    func onAppear() {
        self.reactionMechanismIdentifier = userDefaultRepository.reactionMechanismLanguage
    }
}
