import SwiftUI

struct StatusOverlayView: View {
    let taskState: TaskState
    let dismiss: () -> Void

    private var relativeUpdatedAt: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: taskState.updatedAt, relativeTo: Date())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Now working on")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(taskState.currentTask)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Button(action: dismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                        .padding(6)
                        .background(Circle().fill(Color.white.opacity(0.15)))
                }
                .buttonStyle(.plain)
            }

            VStack(alignment: .leading, spacing: 6) {
                ProgressView(value: taskState.progressPercent, total: 1)
                    .tint(.mint)
                Text("\(Int(taskState.progressPercent * 100))% complete — updated \(relativeUpdatedAt)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            if !taskState.queue.isEmpty {
                Divider().background(Color.white.opacity(0.15))
                Text("Next up")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(taskState.queue.enumerated()), id: \.offset) { index, item in
                        HStack(alignment: .top, spacing: 6) {
                            Text("\(index + 1).")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(item)
                                .font(.system(size: 13, weight: .medium))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
        .padding(16)
        .frame(width: 240, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.25), radius: 15, x: 0, y: 12)
        )
    }
}
