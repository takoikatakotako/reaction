import SwiftUI

struct StudyCategoryListViewRow: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                VStack(spacing: 8) {
                    HStack(spacing: 0) {
                        Text("基礎理論")
                            .font(.system(size: 14))
                            .foregroundStyle(Color(.appMainText))
                        Spacer()
                        Text("23 / 76")
                            .font(.system(size: 14))
                            .foregroundStyle(Color(.appMainText))
                    }

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4.0)
                                .foregroundStyle(Color(.appBackground))
                                .frame(height: 8)
                                .frame(width: geometry.size.width)

                            RoundedRectangle(cornerRadius: 4.0)
                                .foregroundStyle(Color(.appBlueBackground))
                                .frame(height: 8)
                                .frame(width: geometry.size.width * 0.6)

                            RoundedRectangle(cornerRadius: 4.0)
                                .foregroundStyle(Color(.appGreenBackground))
                                .frame(height: 8)
                                .frame(width: geometry.size.width * 0.2)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }

                Image(systemName: "chevron.forward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 9)
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)

            Divider()
        }
    }
}

#Preview {
    StudyCategoryListViewRow()
}
