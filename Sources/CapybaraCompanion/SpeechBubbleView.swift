import SwiftUI

struct SpeechBubbleView: View {
    enum Tone {
        case friendly, focus, alert

        var color: Color {
            switch self {
            case .friendly: return Color(red: 0.25, green: 0.65, blue: 0.82)
            case .focus: return Color(red: 0.37, green: 0.38, blue: 0.86)
            case .alert: return Color(red: 0.92, green: 0.35, blue: 0.42)
            }
        }

        var icon: String {
            switch self {
            case .friendly: return "sparkles"
            case .focus: return "bolt.fill"
            case .alert: return "exclamationmark.triangle.fill"
            }
        }
    }

    let text: String
    let tone: Tone

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: tone.icon)
                .font(.system(size: 14, weight: .semibold))
            Text(text)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .fixedSize(horizontal: false, vertical: true)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            BubbleShape(cornerRadius: 18, tailWidth: 18, tailHeight: 11)
                .fill(tone.color.opacity(0.92))
        )
        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
        .frame(maxWidth: 220, alignment: .leading)
    }
}

private struct BubbleShape: Shape {
    var cornerRadius: CGFloat
    var tailWidth: CGFloat
    var tailHeight: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path(roundedRect: rect, cornerRadius: cornerRadius)
        let tailStart = CGPoint(x: rect.midX - tailWidth / 2, y: rect.maxY)
        let tailTip = CGPoint(x: rect.midX, y: rect.maxY + tailHeight)
        let tailEnd = CGPoint(x: rect.midX + tailWidth / 2, y: rect.maxY)

        path.move(to: tailStart)
        path.addLine(to: tailTip)
        path.addLine(to: tailEnd)
        path.closeSubpath()

        return path
    }
}
