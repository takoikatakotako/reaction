import SwiftUI

struct SettingLangageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack(spacing: 12) {
            Text("Which reaction mechanism is displayed in Japanese or English?")
                .padding(.bottom, 32)
            Button(action: {
                UserDefaultRepository().setSelectedJapanese(false)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("English")
                    .foregroundColor(.gray)
                    .padding()
                    .frame(width: 140)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            })

            Button(action: {
                UserDefaultRepository().setSelectedJapanese(true)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Japanese")
                    .foregroundColor(.gray)
                    .padding()
                    .frame(width: 140)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            })
        }
    }
}

struct ConfigLangageView_Previews: PreviewProvider {
    static var previews: some View {
        SettingLangageView()
    }
}
