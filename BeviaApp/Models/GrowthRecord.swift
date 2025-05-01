//
//  GrowthRecord.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation

struct GrowthRecord: Identifiable, Codable {
    var id: UUID
    var babyId: UUID
    var date: Date
    var weight: Double?
    var height: Double?
    var headCircumference: Double?
    var notes: String?

    init(id: UUID = UUID(), babyId: UUID, date: Date, weight: Double? = nil, height: Double? = nil, headCircumference: Double? = nil, notes: String? = nil) {
        self.id = id
        self.babyId = babyId
        self.date = date
        self.weight = weight
        self.height = height
        self.headCircumference = headCircumference
        self.notes = notes
    }
}

// Extension for file operations
extension GrowthRecord {
    // Common filename pattern for growth records
    static func getFilename(for id: UUID) -> String {
        return "growth_\(id.uuidString).json"
    }
}