import SwiftUI

struct SearchThirdCategoryRow: View {
    let check: Bool
    let name: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if check {
                    Image(R.image.searchCheckBox.name)
                        .padding(.leading, 48)
                } else {
                    Image(R.image.searchCheckBoxOutline.name)
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
