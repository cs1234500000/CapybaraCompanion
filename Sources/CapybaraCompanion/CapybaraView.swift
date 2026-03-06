import SwiftUI
import AppKit

struct CapybaraView: View {
    @EnvironmentObject private var stateStore: TaskStateStore
    @State private var bubbleVisible = false
    @State private var showOverlay = false

    var body: some View {
        ZStack(alignment: .top) {
            if showOverlay {
                StatusOverlayView(
                    taskState: stateStore.taskState,
                    dismiss: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showOverlay = false
                        }
                    }
                )
                .offset(y: -130)
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(2)
            }

            ZStack(alignment: .top) {
                CapybaraIllustration()
                    .frame(width: 220, height: 220)
                    .gesture(dragGesture)

                if let bubble = stateStore.currentBubble, bubbleVisible {
                    SpeechBubbleView(text: bubble.text, tone: bubble.tone)
                        .padding(.top, -18)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .zIndex(1)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    overlayToggleButton
                }
            }
            .padding([.trailing, .bottom], 8)
            .frame(width: 220, height: 220)
        }
        .background(Color.clear)
        .highPriorityGesture(
            TapGesture(count: 2).onEnded {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                    showOverlay.toggle()
                }
            }
        )
        .simultaneousGesture(
            TapGesture().onEnded {
                stateStore.triggerManualCheckIn()
            }
        )
        .onReceive(stateStore.$currentBubble) { bubble in
            Task { @MainActor in
                guard let bubble else {
                    withAnimation(.easeOut(duration: 0.2)) { bubbleVisible = false }
                    return
                }
                withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                    bubbleVisible = true
                }
                try? await Task.sleep(nanoseconds: 5_000_000_000)
                if bubble.id == stateStore.currentBubble?.id {
                    withAnimation { bubbleVisible = false }
                }
            }
        }
    }

    private var overlayToggleButton: some View {
        Button {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                showOverlay.toggle()
            }
        } label: {
            Image(systemName: showOverlay ? "xmark" : "chart.bar.doc.horizontal")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
                .padding(10)
                .background(Circle().fill(Color.black.opacity(0.55)))
                .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .help(showOverlay ? "Hide status" : "Show status")
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard let window = NSApp.windows.first(where: { $0.level == .floating }) else { return }
                let origin = window.frame.origin
                window.setFrameOrigin(NSPoint(
                    x: origin.x + value.translation.width,
                    y: origin.y - value.translation.height
                ))
            }
    }
}
