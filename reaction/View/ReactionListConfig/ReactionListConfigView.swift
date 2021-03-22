import SwiftUI

struct ReactionListConfigView: View {
    @Binding var showingThmbnail: Bool
    @Binding var selectJapanese: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("サムネイル")
                    .font(Font.system(size: 22))
                HStack {
                    Button {
                        showingThmbnail = true
                    } label: {
                        Text("表示")
                            .font(Font.system(size: 28))
                            .frame(width: 100)
                            .foregroundColor(Color.black)
                            .padding(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(16)
                            .opacity(showingThmbnail ? 1.0 : 0.4)
                    }

                    Button {
                        showingThmbnail = false
                    } label: {
                        Text("非表示")
                            .font(Font.system(size: 28))
                            .frame(width: 100)
                            .foregroundColor(Color.black)
                            .padding(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(16)
                            .opacity(!showingThmbnail ? 1.0 : 0.4)
                    }
                }
                .padding(.bottom, 16)
                
                Text("言語")
                    .font(Font.system(size: 22))

                HStack {
                    Button {
                        selectJapanese = true
                    } label: {
                        Text("日本語")
                            .font(Font.system(size: 28))
                            .frame(width: 100)
                            .foregroundColor(Color.black)
                            .padding(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(16)
                            .opacity(selectJapanese ? 1.0 : 0.4)
                    }

                    Button {
                        selectJapanese = false
                    } label: {
                        Text("英語")
                            .font(Font.system(size: 28))
                            .frame(width: 100)
                            .foregroundColor(Color.black)
                            .padding(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(16)
                            .opacity(!selectJapanese ? 1.0 : 0.4)
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct ReactionListConfigView_Previews: PreviewProvider {
    
    struct PreviewWrapper: View {
        @State var showingThmbnail = true
        @State var selectJapanese = true
        var body: some View {
            ReactionListConfigView(showingThmbnail: $showingThmbnail, selectJapanese: $selectJapanese)
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
