import SwiftUI

struct DifficultyStarsView: View {
    let difficulty: Int

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { level in
                Image(systemName: level <= difficulty ? "star.fill" : "star")
                    .foregroundStyle(.yellow)
            }
        }
    }
}
