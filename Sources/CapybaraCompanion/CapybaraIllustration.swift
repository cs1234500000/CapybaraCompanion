import SwiftUI

struct CapybaraIllustration: View {
    var body: some View {
        ZStack {
            Capsule()
                .fill(Color(red: 0.78, green: 0.58, blue: 0.42))
                .frame(width: 190, height: 130)
                .offset(x: -4, y: 22)

            Circle()
                .fill(Color(red: 0.85, green: 0.63, blue: 0.47))
                .frame(width: 100, height: 100)
                .offset(x: 72, y: 12)

            Circle()
                .fill(Color.black.opacity(0.75))
                .frame(width: 10, height: 10)
                .offset(x: 98, y: -4)

            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 0.62, green: 0.41, blue: 0.3))
                .frame(width: 24, height: 12)
                .rotationEffect(.degrees(-18))
                .offset(x: 78, y: -34)

            Capsule()
                .fill(Color(red: 0.5, green: 0.33, blue: 0.23))
                .frame(width: 18, height: 60)
                .offset(x: -42, y: 78)

            Capsule()
                .fill(Color(red: 0.5, green: 0.33, blue: 0.23))
                .frame(width: 18, height: 60)
                .offset(x: 36, y: 80)
        }
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 12)
    }
}
