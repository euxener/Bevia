//
//  DiaperLog.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation

struct DiaperLog: Identifiable, Codable {
    var id: UUID
    var babyId: UUID
    var date: Date
    var time: Date
    var diaperType: DiaperType
    var notes: String?
    
    init(id: UUID = UUID(), babyId: UUID, date: Date, time: Date, diaperType: DiaperType, notes: String? = nil) {
        self.id = id
        self.babyId = babyId
        self.date = date
        self.time = time
        self.diaperType = diaperType
        self.notes = notes
    }
    
    // Internal computed property to be consistent with DailyLog
    var logType: String {
        return "diaper"
    }
    
    // Return the diaper type as string
    var diaperTypeString: String {
        return diaperType.rawValue
    }
}

// Helper extension to convert to/from DailyLog
extension DiaperLog {
    init?(from dailyLog: DailyLog, diaperType: DiaperType) {
        guard dailyLog.logType == "diaper" else {
            return nil
        }
        
        self.id = dailyLog.id
        self.babyId = dailyLog.babyId
        self.date = dailyLog.date
        self.time = dailyLog.time
        self.diaperType = diaperType
        self.notes = dailyLog.notes
    }
    
    func toDailyLog() -> DailyLog {
        return DailyLog(
            id: id,
            babyId: babyId,
            date: date,
            time: time,
            logType: "diaper",
            notes: notes
        )
    }
}
