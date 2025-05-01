import Foundation

// Extension to FileDataService to handle GrowthRecord operations
extension FileDataService {

    // MARK: - Helper methods for GrowthRecord

    private func getGrowthRecordDirectory(babyId: UUID) -> URL {
        return dataDirectory.appendingPathComponent("baby_\(babyId.uuidString)_growth", isDirectory: true)
    }

    private func getGrowthRecordPath(babyId: UUID, recordId: UUID) -> URL {
        let directory = getGrowthRecordDirectory(babyId: babyId)
        return directory.appendingPathComponent(GrowthRecord.getFilename(for: recordId))
    }

    // MARK: - GrowthRecord operations

    func saveGrowthRecord(_ record: GrowthRecord) -> Bool {
        // Ensure the directory exists
        let directory = getGrowthRecordDirectory(babyId: record.babyId)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(record)
            try data.write(to: getGrowthRecordPath(babyId: record.babyId, recordId: record.id))
            return true
        } catch {
            print("Error saving growth record: \(error)")
            return false
        }
    }

    func loadGrowthRecord(babyId: UUID, recordId: UUID) -> GrowthRecord? {
        let filePath = getGrowthRecordPath(babyId: babyId, recordId: recordId)

        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: filePath)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(GrowthRecord.self, from: data)
        } catch {
            print("Error loading growth record: \(error)")
            return nil
        }
    }

    func loadAllGrowthRecords(babyId: UUID) -> [GrowthRecord] {
        let directory = getGrowthRecordDirectory(babyId: babyId)

        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            let fileURLs = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            let growthFiles = fileURLs.filter {$0.lastPathComponent.starts(with: "growth_")}

            var records: [GrowthRecord] = []

            for fileURL in growthFiles {
                if let record = try? loadGrowthRecord(from: fileURL) {
                    records.append(record)
                }
            }

            // Sort records by date (newest first)
            return records.sorted(by: {$0.date > $1.date})
        } catch {
            print("Error loading growth records: \(error)")
            return []
        }
    }

    private func loadGrowthRecord(from fileURL: URL) throws -> GrowthRecord? {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(GrowthRecord.self, from: data)
    }

    func deleteGrowthRecord(babyId: UUID, recordId: UUID) -> Bool {
        let filePath = getGrowthRecordPath(babyId: babyId, recordId: recordId)

        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return false
        }

        do {
            try FileManager.default.removeItem(at: filePath)
                return true
            } catch {
                print("Error deleting growth record: \(error)")
                return false
            }
        }
    }
