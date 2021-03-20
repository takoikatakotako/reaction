import SwiftUI

struct DeveloperRow: View {
    let imageName: String
    let name: String
    
    var body: some View {
        VStack {
            HStack {
                Image(imageName)
                    .resizable()
                    .frame(width: 60, height: 60)
                Text(name)
                    .font(Font.system(size: 20).bold())
                    .foregroundColor(Color.black)
                Spacer()
                
                Image("icon-open")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .opacity(0.8)
            }
            .padding(.horizontal, 16)
            Divider()
        }
    }
}

struct DeveloperRow_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperRow(imageName: "icon-takoika", name: "かびごん小野")
    }
}
