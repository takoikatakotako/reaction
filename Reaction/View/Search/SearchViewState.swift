import Foundation

class SearchViewState: ObservableObject {
    @Published var favoriteColor = 0
    @Published var firstCategories: [FirstCategory] = [
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
                    tag: "Carbonyl-Carboxylic_Acid_Derivative",
                    check: true,
                    thirdCategories: [
                        ThirdCategory(name: "Carboxilic Acid", tag: "Carbonyl-Carboxylic_Carboxilic-Acid", check: true),
                        ThirdCategory(name: "Ester", tag: "Carbonyl-Carboxylic_Acid_Derivative-Ester", check: true),
                        ThirdCategory(name: "Acid Anhydride", tag: "Carbonyl-Carboxylic_Acid_Derivative-Acid_Anhydride", check: true),
                        ThirdCategory(name: "Acid Halide", tag: "Carbonyl-Carboxylic_Acid_Derivative-Acid_Halide", check: true),
                        ThirdCategory(name: "Amide", tag: "Carbonyl-Carboxylic_Acid_Derivative-Amide", check: true),
                        ThirdCategory(name: "Acid Derivative", tag: "Carbonyl-Carboxylic_Acid_Derivative-Acid_Derivative", check: true)
                    ]
                )
            ]
        ),
        FirstCategory(
            name: "Halogen",
            tag: "Halogene",
            check: true,
            secondCategories: [
                SecondCategory(
                    name: "Alkyl Halide",
                    tag: "Halogene-Alkyl_Halide",
                    check: true,
                    thirdCategories: []
                ),
                SecondCategory(
                    name: "Other",
                    tag: "Halogene-Other",
                    check: true,
                    thirdCategories: []
                )
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
                )
            ]
        )
    ]
}
