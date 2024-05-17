import SwiftUI

struct StudyCategoryListView: View {
    @State var favoriteColor = 0
    @State var goStudyView = false

    @State var path: [StudyViewPath] = []

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack {
                        Picker("What is your favorite color?", selection: $favoriteColor) {
                            Text("カテゴリー別").tag(0)
                            Text("年度別").tag(1)
                            Text("試験時間別").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)

                        NavigationLink {
                            StudyCategoryDetailView()
                        } label: {
                            StudyCategoryListViewRow()
                        }

                        NavigationLink {
                            Text("XX")
                        } label: {
                            StudyCategoryListViewRow()
                        }

                        NavigationLink {
                            Text("XX")
                        } label: {
                            StudyCategoryListViewRow()
                        }

                        NavigationLink {
                            Text("XX")
                        } label: {
                            StudyCategoryListViewRow()
                        }

                        NavigationLink {
                            Text("XX")
                        } label: {
                            StudyCategoryListViewRow()
                        }

                        NavigationLink {
                            Text("XX")
                        } label: {
                            StudyCategoryListViewRow()
                        }

                        NavigationLink {
                            Text("XX")
                        } label: {
                            StudyCategoryListViewRow()
                        }

                        NavigationLink {
                            Text("XX")
                        } label: {
                            StudyCategoryListViewRow()
                        }

                        NavigationLink {
                            Text("XX")
                        } label: {
                            StudyCategoryListViewRow()
                        }

                        Spacer()
                            .frame(height: 160)
                    }
                }

                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        NavigationLink(value: StudyViewPath.study) {
                            Text("間違えた問題")
                                .font(.system(size: 18).bold())
                                .foregroundStyle(Color.white)
                                .frame(height: 48)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .background(Color(.appBlueBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        NavigationLink(value: StudyViewPath.study) {
                            Text("チェックから出題")
                                .font(.system(size: 18).bold())
                                .foregroundStyle(Color.white)
                                .frame(height: 48)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .background(Color(.appRedBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal, 16)

                    NavigationLink(value: StudyViewPath.study) {
                        Text("ランダムに出題")
                            .font(.system(size: 18).bold())
                            .foregroundStyle(Color.white)
                            .frame(height: 48)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color(.appGreenBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.horizontal, 16)
                            .padding(.bottom, 8)
                    }

                }
                .clipped()
            }
            .navigationDestination(for: StudyViewPath.self) { pathValue in
                switch pathValue {
                case .studyCategoryDetail:
                    StudyCategoryListView()
                case .studyCategoryList:
                    Text("studyCategoryList")
                case .study:
                    StudyView()
                case .studyDescription:
                    Text("studyDescription")
                case .studyResult:
                    Text("studyResult")
                }

            }
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("基本情報技術者")
                        .font(.system(size: 16).bold())
                        .foregroundStyle(Color.white)
                }
            }
            .toolbarBackground(Color(.appMain), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    StudyCategoryListView()
}
