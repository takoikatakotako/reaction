import SwiftUI

struct SearchSecondCategoryRow: View {
    let check: Bool
    let name: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if check {
                    Image(systemName: "checkmark.square")
                        .padding(.leading, 24)
                } else {
                    Image(systemName: "square")
                        .padding(.leading, 24)
                }
                CommonText(text: name, font: Font.system(size: 12))
            }
            Divider()
        }
    }
}

struct SearchSecondCategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchSecondCategoryRow(check: true, name: "カルボニル基")
    }
}
