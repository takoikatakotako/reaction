import SwiftUI
import LicenseList

struct SettingView: View {
    @StateObject var viewState: SettingViewState

    var body: some View {
        NavigationStack {
            List {
                Section(String(localized: "setting-app-setting")) {
                    Button {
                        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        HStack {
                            Text(String(localized: "setting-language"))
                            Spacer()
                            CommonText(text: viewState.langage, font: Font.system(size: 14))
                        }
                    }

                    Button {
                        viewState.showThumbnailAlert()
                    } label: {
                        HStack {
                            Text(String(localized: "setting-thmbnail"))
                            Spacer()
                            if let thmbnail = viewState.thmbnail {
                                Text(thmbnail ? String(localized: "setting-show") : String(localized: "setting-hidden"))
                            }
                        }
                    }
                }

                Section(String(localized: "setting-developer-info")) {
                    Button(action: {
                        if let url = URL(string: GITHUB_REPOSITORY_URL) {
                            UIApplication.shared.open(url)
                        }
                    }, label: {
                        HStack {
                            CommonText(text: String(localized: "setting-github"), font: Font.system(size: 14))

                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .padding(.trailing, 8)
                        }
                    })
                }

                Section(String(localized: "setting-app-info")) {
                    HStack {
                        CommonText(text: String(localized: "setting-version"), font: Font.system(size: 14))
                        Spacer()
                        Text(viewState.appVersion)
                    }
                    NavigationLink {
                        LicenseListView()
                    } label: {
                        CommonText(text: String(localized: "setting-license"), font: Font.system(size: 14))
                    }
                }

                Section(String(localized: "setting-reset")) {
                    Button {
                        viewState.reset()
                    } label: {
                        CommonText(text: String(localized: "setting-clear-cache"), font: Font.system(size: 14))
                    }
                }
            }
            .onAppear {
                viewState.onAppear()
            }

            .alert("", isPresented: $viewState.showingThmbnailAlert, actions: {
                Button(String(localized: "setting-show-thmbnail")) {
                    viewState.setShowThumbnail()
                }

                Button(String(localized: "setting-hidden-thmbnail")) {
                    viewState.setHiddenThumbnail()
                }

                Button(String(localized: "common-close")) {}
            }, message: {
                CommonText(text: String(localized: "setting-do-you-want-to-display-thumbnails?"), font: Font.system(size: 14))
            })
            .alert("", isPresented: $viewState.showingResetAlert, actions: {

            }, message: {
                CommonText(text: String(localized: "setting-clear-cache-complete"), font: Font.system(size: 14))
            })
            .listStyle(.grouped)
            .navigationTitle(String(localized: "common-setting"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingView(viewState: SettingViewState())
}
