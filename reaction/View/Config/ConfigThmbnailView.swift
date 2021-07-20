import SwiftUI

struct ConfigThmbnailView: View {
    var body: some View {
        VStack {
            Text("サムネイル表示する？")
            
            Button(action: {
                UserDefaultRepository().setShowThmbnail(true)
            }, label: {
                Text("サムネイル表示")
            })
            
            Button(action: {
                UserDefaultRepository().setShowThmbnail(false)
            }, label: {
                Text("サムネイル非表示")
            })
        }
    }
}

struct ConfigThmbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigThmbnailView()
    }
}
