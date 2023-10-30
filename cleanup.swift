#!/usr/bin/swift

// This is a script to clean up a SwiftPM environment.

import Foundation

let fileManager = FileManager.default
let homeDirectory = NSHomeDirectory()
let derivedDataPath = "\(homeDirectory)/Library/Developer/Xcode/DerivedData"

let pathsToClean = [
    "./.build",
    "./Package.resolved",
    "./.swiftpm",
    "\(homeDirectory)/.swiftpm",
    "\(homeDirectory)/Library/Caches/org.swift.swiftpm",
]

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

func deleteDerivedDataFor(project: String) {
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

for path in pathsToClean {
    delete(path: path)
}

if shouldDeleteDerivedData {
    let projectName = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).lastPathComponent
    deleteDerivedDataFor(project: projectName)
} else {
    print("Skipping DerivedData. Use '--clean-derived-data' flag to clean it.")
}

print("🧹 Cleanup completed.")
