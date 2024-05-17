import SwiftUI

struct StudyView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack {
                    Text("P, Q, Rはいずれも命題である。命題Pの真理値は真であり,命題（not P）or Q 及び命題（not Q）or R のいずれの真理値はどれか。ここで, X or Y は X と Y の論理和, not X は X の否定を表す。")
                    
                    Image(.studySample)
                        .resizable()
                    
                    VStack {
                        Text("ア: 16進数表記 00 ビット列と排他的論理和をとる。")
                        Text("ア: 16進数表記 00 ビット列と排他的論理和をとる。16進数表記 00 ビット列と排他的論理和をとる。")
                        Text("ア: 16進数表記 00 ビット列と排他的論理和をとる。")
                        Text("ア: 16進数表記 00 ビット列と排他的論理和をとる。")
                    }
                    
                    HStack {
                        Spacer()
                        Text("出典: 平成31年度春季本試験 問1")
                    }
                }
            }
            
            HStack(spacing: 12) {
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "pencil.line")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(Color.white)
                    }
                    .frame(width: 60, height: 48)
                    .background(Color(.appGreenBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Button {
                    
                } label: {
                    Text("ア")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 18).bold())
                        .frame(width: 60, height: 48)
                        .background(Color(.appGreenBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Button {
                    
                } label: {
                    Text("イ")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 18).bold())
                        .frame(width: 60, height: 48)
                        .background(Color(.appGreenBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Button {
                    
                } label: {
                    Text("ウ")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 18).bold())
                        .frame(width: 60, height: 48)
                        .background(Color(.appGreenBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Button {
                    
                } label: {
                    Text("エ")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 18).bold())
                        .frame(width: 60, height: 48)
                        .background(Color(.appGreenBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
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
        .toolbarBackground(Color(.appMain),for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        StudyView()
    }
}
