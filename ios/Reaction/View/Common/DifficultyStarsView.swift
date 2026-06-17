import SwiftUI

struct DifficultyStarsView: View {
    let difficulty: Int

    var body: some View {
        HStack(spacing: 4) {
            Text("Lv.")
                .font(Font.system(size: 16))
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { level in
                    Image(systemName: level <= difficulty ? "star.fill" : "star")
                }
            }
        }
        .foregroundStyle(.primary)
    }
}
