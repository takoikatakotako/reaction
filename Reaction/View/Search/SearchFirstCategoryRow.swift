import SwiftUI

struct SearchFirstCategoryRow: View {
    let check: Bool
    let name: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if check {
                    Image(R.image.searchCheckBox.name)
                } else {
                    Image(R.image.searchCheckBoxOutline.name)
                }
                Text(name)
            }
            Divider()
        }
    }
}

struct SearchFirstCategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchFirstCategoryRow(check: true, name: "カルボニル基")
    }
}
