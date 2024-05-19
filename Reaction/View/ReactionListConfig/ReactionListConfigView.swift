//import SwiftUI
//
//struct ReactionListConfigView: View {
//    @Binding var showingThmbnail: Bool
//    @Binding var selectJapanese: Bool
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text(selectJapanese ? "サムネイル" : "Thumbnail")
//                    .font(Font.system(size: 22))
//                HStack {
//                    Button {
//                        showingThmbnail = true
//                        UserDefaultRepository().setShowThmbnail(true)
//                    } label: {
//                        Text(selectJapanese ? "表示" : "Show")
//                            .font(Font.system(size: 28))
//                            .frame(width: 120)
//                            .foregroundColor(Color("mainTextColor"))
//                            .padding(12)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 16)
//                                    .stroke(Color("mainTextColor"), lineWidth: 2)
//                            )
//                            .background(Color.gray.opacity(0.7))
//                            .cornerRadius(16)
//                            .opacity(showingThmbnail ? 1.0 : 0.4)
//                    }
//
//                    Button {
//                        showingThmbnail = false
//                        UserDefaultRepository().setShowThmbnail(false)
//                    } label: {
//                        Text(selectJapanese ? "非表示" : "Hide")
//                            .font(Font.system(size: 28))
//                            .frame(width: 120)
//                            .foregroundColor(Color("mainTextColor"))
//                            .padding(12)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 16)
//                                    .stroke(Color("mainTextColor"), lineWidth: 2)
//                            )
//                            .background(Color.gray.opacity(0.7))
//                            .cornerRadius(16)
//                            .opacity(!showingThmbnail ? 1.0 : 0.4)
//                    }
//                }
//                .padding(.bottom, 16)
//
//                Text(selectJapanese ? "言語" : "Langage")
//                    .font(Font.system(size: 22))
//
//                HStack {
//                    Button {
//                        selectJapanese = true
//                        UserDefaultRepository().setSelectedJapanese(true)
//                    } label: {
//                        Text(selectJapanese ? "日本語" : "Japanese")
//                            .font(Font.system(size: 28))
//                            .frame(width: 120)
//                            .foregroundColor(Color("mainTextColor"))
//                            .padding(12)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 16)
//                                    .stroke(Color("mainTextColor"), lineWidth: 2)
//                            )
//                            .background(Color.gray.opacity(0.7))
//                            .cornerRadius(16)
//                            .opacity(selectJapanese ? 1.0 : 0.4)
//                    }
//
//                    Button {
//                        selectJapanese = false
//                        UserDefaultRepository().setSelectedJapanese(false)
//                    } label: {
//                        Text(selectJapanese ? "英語" : "English")
//                            .font(Font.system(size: 28))
//                            .frame(width: 120)
//                            .foregroundColor(Color("mainTextColor"))
//                            .padding(12)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 16)
//                                    .stroke(Color("mainTextColor"), lineWidth: 2)
//                            )
//                            .background(Color.gray.opacity(0.7))
//                            .cornerRadius(16)
//                            .opacity(!selectJapanese ? 1.0 : 0.4)
//                    }
//                }
//
//                Spacer()
//            }
//        }
//    }
//}
//
//struct ReactionListConfigView_Previews: PreviewProvider {
//
//    struct PreviewWrapper: View {
//        @State var showingThmbnail = true
//        @State var selectJapanese = true
//        var body: some View {
//            ReactionListConfigView(showingThmbnail: $showingThmbnail, selectJapanese: $selectJapanese)
//        }
//    }
//
//    static var previews: some View {
//        PreviewWrapper()
//    }
//}
