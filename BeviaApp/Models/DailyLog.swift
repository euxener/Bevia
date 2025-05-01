//
//  DailyLog.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation

struct DailyLog: Identifiable, Codable {
    var id: UUID
    var babyId: UUID
    var date: Date
    var time: Date
    var logType: String
    var notes: String?
    
    init(id: UUID = UUID(), babyId: UUID, date: Date, time: Date, logType: String, notes: String? = nil) {
        self.id = id
        self.babyId = babyId
        self.date = date
        self.time = time
        self.logType = logType
        self.notes = notes
    }
    
    // Helper for getting only the time component
    var timeOfDay: TimeInterval {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        return TimeInterval(components.hour! * 3600 + components.minute! * 60)
    }
}

// Extension for file operations
extension DailyLog {
    // Common filename patter for daily logs
    static func getFilename(for id: UUID) -> String {
        return "log_\(id.uuidString).json"
    }
}
