import SwiftUI

struct SearchResult: View {
    let searchResultType: SearchTargetType
    let withoutCheck: Bool
    let firstCategories: [FirstCategory]
    var body: some View {
        
        VStack {
            if searchResultType == .reactant {
                Text("探すのは出発物")
            } else if searchResultType == .product {
                Text("探すのは生成物")
            }
            
            ForEach(firstCategories) { firstCategory in
                if firstCategory.check {
                    Text(firstCategory.name)
                }
                
                ForEach(firstCategory.secondCategories) { secondCategory in
                    if secondCategory.check {
                        Text(secondCategory.name)
                    }
                    
                    ForEach(secondCategory.thirdCategories) { thirdCategory in
                        if thirdCategory.check {
                            Text(thirdCategory.name)
                        }
                    }
                }
            }
            
            if withoutCheck {
                Text("↑のタグがついているもの以外を探す")
            } else {
                Text("↑のタグがついているものを探す")
            }
        }
    }
}

struct SearchResult_Previews: PreviewProvider {
    static var previews: some View {
        SearchResult(searchResultType: .reactant, withoutCheck: true, firstCategories: [])
    }
}
