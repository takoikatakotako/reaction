import SwiftUI

struct ConfigThmbnailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            Text("サムネイル表示する？")
            
            Button(action: {
                UserDefaultRepository().setShowThmbnail(true)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("サムネイル表示")
            })
            
            Button(action: {
                UserDefaultRepository().setShowThmbnail(false)
                presentationMode.wrappedValue.dismiss()
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
