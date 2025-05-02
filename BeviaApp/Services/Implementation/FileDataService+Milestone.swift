//
//  FileDataService+Milestone.swift
//  Bevia
//
//  Created by Eugenio Herrera on 01/05/25.
//
import Foundation

// Extension to FileDataService to handle Milestone operations
extension FileDataService {
    
    // MARK: - Helper methods for Milestone
    
    private func getMilestoneDirectory(babyId: UUID) -> URL {
        return dataDirectory.appendingPathComponent("baby_\(babyId.uuidString)_milestone", isDirectory: true)
    }
    
    private func getMilestonePath(babyId: UUID, milestoneId: UUID) -> URL {
        let directory = getMilestoneDirectory(babyId: babyId)
        return directory.appendingPathComponent(Milestone.getFilename(for: milestoneId))
    }
    
    // MARK: - Milestone operations
    
    func saveMilestone(_ milestone: Milestone) -> Bool {
        // Ensure directory exists
        let directory = getMilestoneDirectory(babyId: milestone.babyId)
        try? FileManager.default
            .createDirectory(at: directory, withIntermediateDirectories: true)
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(milestone)
            try data
                .write(
                    to: getMilestonePath(
                        babyId: milestone.babyId,
                        milestoneId: milestone.id
                    )
                )
            return true
        } catch {
            print("Error saving milestone: \(error)")
            return false
        }
    }
    
    func loadMilestone(babyId: UUID, milestoneId: UUID) -> Milestone? {
        let filePath = getMilestonePath(
            babyId: babyId,
            milestoneId: milestoneId
        )
        
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: filePath)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(Milestone.self, from: data)
        } catch {
            print("Error loading milestone: \(error)")
            return nil
        }
    }
    
    func loadAllMilestones(babyId: UUID) -> [Milestone] {
        let directory = getMilestoneDirectory(babyId: babyId)
        
        do {
            try FileManager.default
                .createDirectory(
                    at: directory,
                    withIntermediateDirectories: true
                )
            let fileURLs = try FileManager.default.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: nil
            )
            let milestoneFiles = fileURLs.filter {
                $0.lastPathComponent.starts(with: "milestone_")
            }
            
            var milestones: [Milestone] = []
            
            for fileURL in milestoneFiles {
                if let milestone = try? loadMilestone(from: fileURL) {
                    milestones.append(milestone)
                }
            }
            
            // Sort milestones by achieved date (achieved first, then by name)
            return milestones.sorted { (a, b) in
                if a.isAchieved && !b.isAchieved {
                    return true
                } else if !a.isAchieved && b.isAchieved {
                    return false
                } else if let dateA = a.achievedDate, let dateB = b.achievedDate {
                    return dateA > dateB
                } else {
                    return a.name < b.name
                }
            }
        } catch {
            print("Error loading milestones \(error)")
            return []
        }
    }
    
    private func loadMilestone(from fileURL: URL) throws -> Milestone? {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Milestone.self, from: data)
    }
    
    func deleteMilestone(babyId: UUID, milestoneID: UUID) -> Bool {
        let filePath = getMilestonePath(
            babyId: babyId,
            milestoneId: milestoneID
        )
        
        do {
            try FileManager.default.removeItem(at: filePath)
            return true
        } catch {
            print("Error deleting milestone: \(error)")
            return false
        }
    }
}
