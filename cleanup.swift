#!/usr/bin/swift

// This is a script to clean up a SwiftPM environment.

import Foundation

let fileManager = FileManager.default
let homeDirectory = NSHomeDirectory()

let derivedDataPath = "\(homeDirectory)/Library/Developer/Xcode/DerivedData"

func pathsToClean(for path: String) -> [String] {
    [
        "\(path)/.build",
        "\(path)/Package.resolved",
        "\(path)/.swiftpm",
        "\(homeDirectory)/.swiftpm",
        "\(homeDirectory)/Library/Caches/org.swift.swiftpm",
    ]
}

func delete(path: String) {
    do {
        if fileManager.fileExists(atPath: path) {
            try fileManager.removeItem(atPath: path)
            print("✅ Deleted: \(path)")
        } else {
            print("❕ Path not found, skipped: \(path)")
        }
    } catch {
        print("❌ Error deleting path \(path): \(error)")
    }
}

func deleteDerivedData(for project: String) {
    do {
        let derivedDataContents = try fileManager.contentsOfDirectory(atPath: derivedDataPath)
        let projectFolder = derivedDataContents.first { $0.contains(project) }
        if let projectFolder = projectFolder {
            let fullPath = "\(derivedDataPath)/\(projectFolder)"
            delete(path: fullPath)
        } else {
            print("❕ No DerivedData found for project \(project).")
        }
    } catch {
        print("❌ Failed to access DerivedData directory: \(error)")
    }
}

let arguments = CommandLine.arguments
let shouldDeleteDerivedData = arguments.contains("--clean-derived-data")

let projectPath: String
if
    let pathIndex = arguments.firstIndex(of: "--path"),
    arguments.count > pathIndex + 1
{
    projectPath = arguments[pathIndex + 1]
} else {
    projectPath = fileManager.currentDirectoryPath
}

let projectName = URL(fileURLWithPath: projectPath).lastPathComponent

for path in pathsToClean(for: projectPath) {
    delete(path: path)
}

if shouldDeleteDerivedData {
    let projectName = URL(fileURLWithPath: fileManager.currentDirectoryPath).lastPathComponent
    deleteDerivedData(for: projectName)
} else {
    print("Skipping DerivedData. Use '--clean-derived-data' flag to clean it.")
}

print("🧹 Cleanup completed.")
