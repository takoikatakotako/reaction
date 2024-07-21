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
                            Text(viewState.langage)
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
                            Text(String(localized: "setting-github"))
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .padding(.trailing, 8)
                        }
                    })
                }

                Section(String(localized: "setting-app-info")) {
                    HStack {
                        Text(String(localized: "setting-version"))
                        Spacer()
                        Text(viewState.appVersion)
                    }
                    NavigationLink {
                        LicenseListView()
                    } label: {
                        Text(String(localized: "setting-license"))
                    }
                }

                Section(String(localized: "setting-reset")) {
                    Button {
                        viewState.reset()
                    } label: {
                        Text(String(localized: "setting-clear-cache"))
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
                Text(String(localized: "setting-do-you-want-to-display-thumbnails?"))
            })
            .alert("", isPresented: $viewState.showingResetAlert, actions: {

            }, message: {
                Text(String(localized: "setting-clear-cache-complete"))
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
