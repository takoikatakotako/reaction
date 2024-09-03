import SwiftUI

struct DeveloperRow: View {
    let imageName: String
    let role: String
    let name: String

    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 8) {
                CommonText(text: role, font: Font.system(size: 16).bold())
                CommonText(text: name, font: Font.system(size: 20).bold())
            }
            Spacer()

            Image(R.image.iconOpen.name)
                .resizable()
                .frame(width: 24, height: 24)
                .opacity(0.8)
        }
    }
}

struct DeveloperRow_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperRow(imageName: "icon-takoika", role: "プログラマー", name: "かびごん小野")
            .previewLayout(.sizeThatFits)
    }
}
