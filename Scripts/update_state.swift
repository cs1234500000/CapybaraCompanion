#!/usr/bin/env swift
import Foundation

struct TaskState: Codable {
    var currentTask: String
    var progressPercent: Double
    var queue: [String]
    var updatedAt: Date
}

enum Arg: String {
    case task = "--task"
    case progress = "--progress"
    case queue = "--queue"
    case resetQueue = "--reset-queue"
    case help = "--help"
}

func usage() {
    print("""
    Usage: swift Scripts/update_state.swift [--task \"New task\"] [--progress 0.42|42]
                                            [--queue \"item1|item2\"] [--reset-queue]
    """)
}

let args = Array(CommandLine.arguments.dropFirst())
if args.contains(Arg.help.rawValue) {
    usage()
    exit(0)
}

var iterator = args.makeIterator()
var newTask: String?
var newProgress: Double?
var providedQueue = false
var newQueue: [String] = []

while let token = iterator.next() {
    switch token {
    case Arg.task.rawValue:
        guard let value = iterator.next() else { fatalError("--task requires a value") }
        newTask = value
    case Arg.progress.rawValue:
        guard let value = iterator.next(), let raw = Double(value) else {
            fatalError("--progress requires a numeric value")
        }
        newProgress = raw > 1 ? min(max(raw / 100.0, 0), 1) : min(max(raw, 0), 1)
    case Arg.queue.rawValue:
        guard let value = iterator.next() else { fatalError("--queue requires a value") }
        providedQueue = true
        newQueue = value
            .split(separator: "|")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    case Arg.resetQueue.rawValue:
        providedQueue = true
        newQueue = []
    default:
        fatalError("Unknown argument: \(token)")
    }
}

let supportDir = FileManager.default
    .homeDirectoryForCurrentUser
    .appendingPathComponent("Library/Application Support/CapybaraCompanion", isDirectory: true)
let stateURL = supportDir.appendingPathComponent("state.json")

let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601
let encoder = JSONEncoder()
encoder.dateEncodingStrategy = .iso8601
encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

var state = TaskState(
    currentTask: "Scaffolding companion",
    progressPercent: 0.1,
    queue: [],
    updatedAt: Date()
)

if let data = try? Data(contentsOf: stateURL),
   let existing = try? decoder.decode(TaskState.self, from: data) {
    state = existing
}

if let task = newTask { state.currentTask = task }
if let progress = newProgress { state.progressPercent = progress }
if providedQueue { state.queue = newQueue }
state.updatedAt = Date()

try? FileManager.default.createDirectory(at: supportDir, withIntermediateDirectories: true)
let data = try encoder.encode(state)
try data.write(to: stateURL, options: .atomic)

print("Updated state.json at \(stateURL.path)")
