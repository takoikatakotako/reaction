import SwiftUI

struct ConfigThmbnailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack(spacing: 12) {
            Text("Do you want to display thumbnails?")
                .padding(.bottom, 32)

            Button(action: {
                UserDefaultRepository().setShowThmbnail(true)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Show")
                    .foregroundColor(.gray)
                    .padding()
                    .frame(width: 140)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            })

            Button(action: {
                UserDefaultRepository().setShowThmbnail(false)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Hidden")
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

struct ConfigThmbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigThmbnailView()
    }
}
