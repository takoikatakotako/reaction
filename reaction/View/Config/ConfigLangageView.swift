import SwiftUI

struct ConfigLangageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            Text("反応機構は日本語と英語どっちで表示する？")
            
            Button(action: {
                UserDefaultRepository().setSelectedJapanese(false)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("英語")
            })
            
            Button(action: {
                UserDefaultRepository().setSelectedJapanese(true)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("日本語")
            })
        }
    }
}

struct ConfigLangageView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigLangageView()
    }
}
