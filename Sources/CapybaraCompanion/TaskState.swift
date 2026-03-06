import Foundation
import Combine

struct TaskState: Codable {
    var currentTask: String
    var progressPercent: Double
    var queue: [String]
    var updatedAt: Date
}

struct BubbleEvent: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let tone: SpeechBubbleView.Tone
}

final class TaskStateStore: ObservableObject {
    @Published private(set) var taskState = TaskState(
        currentTask: "Bootstrapping companion",
        progressPercent: 0.1,
        queue: ["Hook up overlay panel", "Add JSON updater"],
        updatedAt: Date()
    )

    @Published var currentBubble: BubbleEvent?

    private var source: DispatchSourceFileSystemObject?
    private let fileURL: URL
    private let queue = DispatchQueue(label: "capybara.state", qos: .userInitiated)

    init() {
        let supportDir = FileManager.default
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Application Support/CapybaraCompanion", isDirectory: true)
        self.fileURL = supportDir.appendingPathComponent("state.json")
    }

    func startWatching() {
        ensureSeedState()
        loadState()

        let descriptor = open(fileURL.path, O_EVTONLY)
        guard descriptor != -1 else { return }

        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: descriptor,
            eventMask: .write,
            queue: queue
        )

        source.setEventHandler { [weak self] in
            self?.loadState()
        }

        source.setCancelHandler {
            close(descriptor)
        }

        source.resume()
        self.source = source
    }

    func triggerManualCheckIn() {
        let text = "Checking in—need anything from me?"
        currentBubble = BubbleEvent(text: text, tone: .friendly)
    }

    private func ensureSeedState() {
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.createDirectory(
                at: fileURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            write(state: taskState)
        }
    }

    private func loadState() {
        guard let data = try? Data(contentsOf: fileURL),
              let incoming = try? JSONDecoder().decode(TaskState.self, from: data)
        else { return }

        DispatchQueue.main.async { [weak self] in
            self?.taskState = incoming
            self?.currentBubble = BubbleEvent(
                text: "Working on \(incoming.currentTask) (\(Int(incoming.progressPercent * 100))%)",
                tone: .focus
            )
        }
    }

    private func write(state: TaskState) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let data = try? encoder.encode(state) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
}
