import SwiftUI

struct SearchThirdCategoryRow: View {
    let check: Bool
    let name: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if check {
                    Image(systemName: "checkmark.square")
                        .padding(.leading, 48)
                } else {
                    Image(systemName: "square")
                        .padding(.leading, 48)
                }
                Text(name)
            }
            Divider()
        }
    }
}

struct SearchThirdCategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchThirdCategoryRow(check: true, name: "カルボニル基")
    }
}
