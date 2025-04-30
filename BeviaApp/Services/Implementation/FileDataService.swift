//
//  FileDataService.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation

class FileDataService: DataServiceProtocol {
    private let dataDirectory: URL

    init(directory: URL? = nil) {
        if let directory = directory {
            self.dataDirectory = directory
        } else {
            // Use Documents directory by default
            let paths = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask)
            self.dataDirectory = paths[0].appendingPathComponent(
                "BabyTracker",isDirectory: true)
        }

        // Create directory if it doesn't exist
        try? FileManager.default.createDirectory(
            at: dataDirectory,withIntermediateDirectories: true)
    }

    // MARK: - Helper methods

    private func getBabyFilePath(id: UUID) -> URL {
        return dataDirectory.appendingPathComponent("baby_\(id.uuidString).json")
    }

    // MARK: - Baby operations

    func saveBaby(_ baby: Baby) -> Bool {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(baby)
            try data.write(to: getBabyFilePath(id: baby.id))
            return true
        } catch {
            print("Error saving baby: \(error)")
            return false
        }
    }

    func loadBaby(withID id: UUID) -> Baby? {
        let filePath = getBabyFilePath(id: id)

        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: filePath)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(Baby.self, from: data)
        } catch {
            print("Error loading baby: \(error)")
            return nil
        }
    }
}
