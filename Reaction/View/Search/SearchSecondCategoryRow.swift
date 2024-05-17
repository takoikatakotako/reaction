import SwiftUI

struct SearchSecondCategoryRow: View {
    let check: Bool
    let name: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if check {
                    Image(R.image.searchCheckBox.name)
                        .padding(.leading, 24)
                } else {
                    Image(R.image.searchCheckBoxOutline.name)
                        .padding(.leading, 24)
                }
                Text(name)
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
